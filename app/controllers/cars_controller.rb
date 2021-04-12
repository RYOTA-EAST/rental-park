class CarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_car_params, only: [:show, :edit, :update, :destroy]
  before_action :move_to_top, only: [:edit, :update, :destroy]
  def index
    @car = Car.where(user_id: current_user.id)
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to cars_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @car.update(car_params)
      redirect_to cars_path
    else
      render :edit
    end
  end

  def destroy
    if @car.destroy
      redirect_to cars_path
    else
      render :index
    end
  end

  private

  def car_params
    params.require(:car).permit(:vehicle_type, :city, :class_number, :registration_type, :designated_number, :number_image,
                                :vehicle_image, :use_stop).merge(user_id: current_user.id)
  end

  def set_car_params
    @car = Car.find(params[:id])
  end

  def move_to_top
    redirect_to top_page_parks_path unless current_user == @car.user
  end
end
