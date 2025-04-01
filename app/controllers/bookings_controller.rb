class BookingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookings = current_user.bookings.order(created_at: :desc)  # Fetch only logged-in user's bookings
  end

  def new
    @event = Event.find(params[:event_id]) if params[:event_id]
    @booking = Booking.new
  end


  def create
    event = Event.find(params[:event_id])

    total_booked_tickets = event.bookings.where(status: "confirmed").sum(:tickets)
    available_seats = event.total_seats - total_booked_tickets

    if params[:booking][:tickets].to_i > available_seats
      flash[:alert] = "Not enough seats available!"
      redirect_back(fallback_location: root_path) and return
    end

    @booking = current_user.bookings.create(
      event_id: event.id,
      tickets: params[:booking][:tickets].to_i,
      total_price: event.price * params[:booking][:tickets].to_i,
      status: "pending"
    )

    if @booking.persisted?
      redirect_to new_booking_payment_path(@booking)
    else
      flash[:alert] = "Booking failed!"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @booking = Booking.find(params[:id])

    if @booking.user != current_user
      flash[:alert] = "Unauthorized access!"
      redirect_to root_path
    end
  end

  # ✅ Cancel Booking Action
  def cancel
    @booking = current_user.bookings.find(params[:id])

    if @booking.status == "confirmed"
      @booking.update(status: "cancelled")

      # Refund logic can be added here if needed

      BookingMailer.cancellation_email(@booking).deliver_now  # ✅ Send cancellation email

      flash[:alert] = "Booking cancelled successfully. Your amount will be refunded within one day."
    else
      flash[:alert] = "This booking cannot be cancelled."
    end

    redirect_to bookings_path
  end

  private

  def booking_params
    params.require(:booking).permit(:event_id, :tickets, :total_price, :status)
  end
end
