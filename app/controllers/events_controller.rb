class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_params, only: [:show, :edit, :update, :destroy]
  def index
    @event = Event.where(user_id: current_user.id).includes(:park, :car)
  end

  def new
    @park_find = Park.find(params[:park_id])
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save!
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end
  
  def edit
    @park_find = Park.find(params[:park_id])
  end
  
  def update
    if @event.update(event_params)
    redirect_to park_event_path(park_id: params[:park_id], id: params[:id])
    else
      render :edit
    end
  end
  
  def destroy
    if @event.destroy
      redirect_to root_path
    else
      render :index
    end
  end
  private
  def event_params
    params.require(:event).permit(:start_date, :end_date, :memo, :cancel_flag, :car_id).merge(park_id: params[:park_id], user_id: current_user.id)
  end

  def set_event_params
    @event = Event.find(params[:id])
  end
end
