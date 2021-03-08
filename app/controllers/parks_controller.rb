class ParksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_park_params, only: [:show, :edit, :update, :destroy]
  
  def index
    @park_all = Park.all
  end

  def new
    @park = Park.new
  end

  def create
    @park = Park.new(park_params)
    if @park.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end
  
  def edit
  end
  
  def update
    if @park_find.update(park_params)
      redirect_to park_path
    else
      render :edit
    end
  end
  
  def destroy
    if @park_find.destroy
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def park_params
    params.require(:park).permit(:name, :number, :postal_code, :prefecture_id, :city, :address, :explosive, :unit_price, :start_time, :end_time).merge(user_id: current_user.id)
  end
  
  def set_park_params
    @park_find = Park.find(params[:id])
  end

end
