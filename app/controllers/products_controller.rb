class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_trip

  respond_to :html

  def index
    @products = Product.all
    respond_with(@products)
  end

  def show
    respond_with([@trip, @product])
  end

  def new
    @product = Product.new
    4.times { @product.pictures.build }
    @product.purchasings.build
    respond_with([@trip, @product])
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    @product.trip = @trip
    @product.save
    respond_with([@trip, @product])
  end

  def update
    @product.update(product_params)
    respond_with([@trip, @product])
  end

  def destroy
    @product.destroy
    respond_with([@trip, @product])
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def product_params
      params.require(:product).permit(:name, :brand, :price, :color, :size, pictures_attributes: [:attachment], purchasings_attributes: [:expect_time_start, :expect_time_end, :remuneration, :memo, :quantity])
    end
end
