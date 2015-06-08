class Purchasing
  include Mongoid::Document
  include Mongoid::Timestamps

  field :expect_time_start, type: Date #期望到货时间
  field :expect_time_end, type: Date #期望到货时间
  field :remuneration, type: BigDecimal #酬金
  field :memo, type: String #备注
  field :quantity, type: BigDecimal #数量
  field :status, type: String, default: 'applying'

  belongs_to :user
  belongs_to :trip
  belongs_to :product

  validates_presence_of :expect_time_start, :expect_time_end, :remuneration, :memo, :quantity
  

  before_create do
    #创建商品同时,创建的需求
    self.user_id = self.product.user_id if self.product.purchasings.count == 0
    self.trip_id = self.product.trip_id
  end

  after_create do
    self.trip.update_attributes(pur_num: self.trip.pur_num+1)
    self.product.update_attributes(pur_num: self.product.pur_num+1)
  end
end
