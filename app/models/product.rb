class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :pictures, :cascade_callbacks => true
  accepts_nested_attributes_for :pictures
  has_many :purchasings, :dependent => :destroy
  accepts_nested_attributes_for :purchasings
  belongs_to :trip
  belongs_to :user

  field :expiration_date, type: Date #下单截止日期
  field :name, type: String #产品名称
  field :brand, type: String #品牌
  field :price, type: BigDecimal #预计单价
  field :color, type: String #颜色
  field :size, type: String #商品尺寸，规格及大小
  field :pur_num, type: BigDecimal, default: 0

  before_create do
    self.expiration_date = self.trip.expiration_date
  end
end