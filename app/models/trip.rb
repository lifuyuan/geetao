class Trip
  include Mongoid::Document
  include Mongoid::Timestamps
  
  DEST_STATE = [['美国', 'us'], ['日本', 'jp'], ['韩国', 'kr'], ['德国', 'de'], ['澳大利亚', 'au'], ['其他', 'other']]
  field :trip_name, type: String #行程名称
  field :departure_date, type: Date #出发日期
  field :return_date, type: Date #返回日期
  field :expiration_date, type: Date #下单截止日期
  field :trip_desc, type: String #行程描述
  field :status, type: String, default: 'created'

  belongs_to :user
  embeds_many :pictures, :cascade_callbacks => true
  accepts_nested_attributes_for :pictures
  has_many :purchasings, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :trip_name, :departure_date, :return_date, :expiration_date, :trip_desc
  
end
