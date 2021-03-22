class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_params, only: [:show, :edit, :update, :cancel]
  def index
    @event = Event.where(user_id: current_user.id).includes(:park, :car).order(start_date: "DESC")
  end

  def new
    @park_find = Park.find(params[:park_id])
    @event = Event.new
    @events = Event.where(park_id:params[:park_id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path
    else
      @park_find = Park.find(params[:park_id])
      @events = Event.where(park_id:params[:park_id])
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
  
  def cancel
    @event = Event.find(params[:id])
    @event.cancel_flag = TRUE
    if @event.update(event_params_cancel)
      redirect_to events_path
    else
      render :index
    end
  end


  private
  def event_params
    params.require(:event).permit(:start_date, :end_date, :memo, :cancel_flag, :car_id).merge(park_id: params[:park_id], user_id: current_user.id)
  end
  def event_params_cancel
    params.permit(:start_date, :end_date, :memo, :cancel_flag, :car_id).merge(park_id: params[:park_id], user_id: current_user.id)
  end

  def set_event_params
    @event = Event.find(params[:id])
  end
end
