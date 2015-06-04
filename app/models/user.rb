class User
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :avatar, 
               :styles => { :medium => '100x100#', :small => ['48x48#'], :large => ['250x250#'] }

  validates_attachment_content_type :avatar, 
               :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  
  before_create :assign_default_role
  before_save :ensure_authentication_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  index({email: 1},{unique: true, name: "user_email_index"})
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  #field :confirmation_token,   type: String
  #field :confirmed_at,         type: Time
  #field :confirmation_sent_at, type: Time
  #field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :name, type: String
  field :authentication_token, type: String

  belongs_to :role

  has_many :trips
  has_many :products
  has_many :purchasings
  has_many :comments

  validates :name, presence: true, uniqueness: { case_sensitive: false},
                   #exclusion: { in: BLACK_LIST, message: I18n.t("is_reserved_word") },
                   format: { without: /(\-| |\.|\/|\\)/, message: "不能包含横线, 斜线, 句点或空格" }


  def gravatar_url(dimension)
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{dimension}&d=retro"
  end

  def has_avatar?
    self.avatar.present?
  end

  def avatar_url(style)
    self.has_avatar? ? self.avatar.url(style.to_sym) : self.gravatar_url({"small"=>48, "medium"=>100, "large"=>250}[style.to_s])
  end

  #token为空时自动生成新的token
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
 
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  protected
    def assign_default_role
      self.role ||= Role.find_by(name: 'client')
    end
end
