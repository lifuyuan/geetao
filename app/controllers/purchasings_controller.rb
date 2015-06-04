class PurchasingsController < ApplicationController
  before_action :set_purchasing, only: [:show, :edit, :update, :destroy]
  before_action :set_product
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  respond_to :html, :json

  def index
    @purchasings = Purchasing.all
    respond_with(@purchasings)
  end

  def show
    respond_with([@product, @purchasing])
  end

  def new
    @purchasing = Purchasing.new
    respond_with([@product, @purchasing])
  end

  def edit
  end

  def create
    @purchasing = Purchasing.new(purchasing_params)
    @purchasing.user = current_user
    @purchasing.product = @product
    @purchasing.save
    respond_with([@product, @purchasing])
  end

  def update
    @purchasing.update(purchasing_params)
    respond_with([@product, @purchasing])
  end

  def destroy
    @purchasing.destroy
    respond_with([@product, @purchasing])
  end

  private
    def set_purchasing
      @purchasing = Purchasing.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def purchasing_params
      params.require(:purchasing).permit(:expect_time_start, :expect_time_end, :remuneration, :memo, :quantity)
    end
end
