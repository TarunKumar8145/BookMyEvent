class BookingMailer < ApplicationMailer
  default from: "tarun123asd@gmail.com"  # Change this to your email

  def booking_confirmation(booking)
    @booking = booking
    @user = booking.user
    @event = booking.event

    mail(to: @user.email, subject: "Booking Confirmation for #{@event.event_name}")
  end
  def cancellation_email(booking)
    @booking = booking
    mail(to: @booking.user.email, subject: "Your Booking for #{@booking.event.event_name} has been Cancelled")
  end
end
