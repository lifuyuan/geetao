class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, type: String
  field :commentable_type, type: String

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :content, :commentable_type

  after_create do
    self.update_attributes(commentable_id: BSON::ObjectId.from_string(self.commentable_id))
  end
end
