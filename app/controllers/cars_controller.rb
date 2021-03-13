class CarsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_car_params, only: [:edit, :update, :destroy]
  def new
    @car = Car.new
  end
  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to root_path
    else
      render :new
    end
  end
  def edit
    
  end
  def update
    
  end
  def destroy
    
  end
  private
  def car_params
    params.require(:car).permit(:vehicle_type, :city, :class_number, :registration_type, :designated_number).merge(user_id: current_user.id)
  end
  def set_car_params
    
  end
end
