class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_admin!, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @events = Event.all
  end



  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:id])  # ✅ Corrected syntax
  end

  def authenticate_admin!
    unless current_user&.admin?
      redirect_to events_path, alert: "You are not authorized to perform this action."
    end
  end

  def event_params
    params.require(:event).permit(:event_name, :description, :date, :location, :venue, :total_seats, :price, :image, :category)
  end
end  # ✅ Ensure class ends properly here
