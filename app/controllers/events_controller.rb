class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_params, only: [:show, :edit, :update, :cancel]
  before_action :move_to_top, only: [:show, :edit, :update, :destroy]
  def index
    @event = Event.where(user_id: current_user.id).where.not(park_id: current_user.parks.ids).includes(:park, :car,
                                                                                                       :user).order(start_date: 'DESC')
  end

  def new
    @park_find = Park.find(params[:park_id])
    if @park_find.rending_stop == true || Car.where(user_id: current_user.id).empty?
      redirect_to park_path(params[:park_id])
    else
      @event = Event.new
      @events = Event.where(park_id: params[:park_id], cancel_flag: false)
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      if current_user == @event.park.user
        redirect_to "/parks/#{@event.park.id}?start_date=#{@event.start_date.strftime('%Y-%m-%d')}"
      else
        redirect_to events_path
      end
    else
      @park_find = Park.find(params[:park_id])
      @events = Event.where(park_id: params[:park_id], cancel_flag: false)
      render :new
    end
  end

  def show
  end

  def edit
    @park_find = Park.find(params[:park_id])
    @events = Event.where(park_id: params[:park_id], cancel_flag: false).includes(:user)
  end

  def update
    if @event.update(event_params)
      if @event.cancel_flag == true
        if current_user == @event.park.user
          redirect_to park_path(params[:park_id])
        else
          redirect_to events_path
        end
      else
        redirect_to park_event_path(park_id: params[:park_id], id: params[:id])
      end
    else
      @park_find = Park.find(params[:park_id])
      @events = Event.where(park_id: params[:park_id], cancel_flag: false).includes(:user)
      render :edit
    end
  end

  private

  def event_params
    params.require(:event).permit(:start_date, :end_date, :memo, :cancel_flag, :car_id).merge(park_id: params[:park_id],
                                                                                              user_id: current_user.id)
  end

  def set_event_params
    @event = Event.find(params[:id])
  end

  def move_to_top
    redirect_to top_page_parks_path unless current_user == @event.user
  end
end
