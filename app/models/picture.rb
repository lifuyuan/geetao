class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :trip, :inverse_of => :pictures

  has_mongoid_attached_file :attachment,
    :styles => { :medium => '250x250>', :small => ['60x60#'], :large => ['500x500#'] }
  validates_attachment_content_type :attachment, 
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
