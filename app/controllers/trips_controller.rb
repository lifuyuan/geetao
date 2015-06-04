class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :select_application, :update_application, :commit_application]
  before_filter :authenticate_user_from_token!, only: [:new, :edit, :create, :update, :destroy, :select_application, :update_application, :commit_application]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :select_application, :update_application, :commit_application]


  respond_to :html, :json

  def index
    @trips = Trip.all
    respond_with(@trips)
  end

  def show
    @purchasing = Purchasing.new
    respond_with(@trip)
  end

  def new
    @trip = Trip.new
    3.times { @trip.pictures.build }
    respond_with(@trip)
  end

  def edit
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    @trip.save
    respond_with(@trip)
  end

  def update
    @trip.update(trip_params)
    respond_with(@trip)
  end

  def destroy
    @trip.destroy
    respond_with(@trip)
  end

  def select_application
  end

  def update_application
    if params[:checkbox].nil? || params[:checkbox].blank?
      flash[:alert] = "您必须至少选择一个代购请求"
      redirect_to "/trips/#{@trip.id}/select_application"
    else
      params[:checkbox].each {|p| Purchasing.find(p).update_attributes(status: "selected")}
      Purchasing.where(status: "created").each {|p| p.update_attributes(status: "unselected")}
      @trip.update_attributes(status: "selected")
      respond_with(@trip)
    end
  end

  def commit_application
    @trip.update_attributes(status: "committed")
    respond_with(@trip)
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def trip_params
      params.require(:trip).permit(:trip_name, :departure_date, :return_date, :expiration_date, :trip_desc, pictures_attributes: [:attachment])
    end
end
