class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @booking = Booking.find_by(id: params[:booking_id])

    if @booking.nil?
      flash[:alert] = "Booking not found!"
      redirect_to root_path and return
    end
  end

  def create
    @booking = Booking.find_by(id: params[:id])

    if @booking.nil?
      flash[:alert] = "Booking not found!"
      redirect_to root_path and return
    end

    @event = @booking.event

    credit_card = ActiveMerchant::Billing::CreditCard.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      number: params[:card_number],
      month: params[:expiry_month],
      year: params[:expiry_year],
      verification_value: params[:cvv]
    )

    if credit_card.valid?
      gateway = ActiveMerchant::Billing::BogusGateway.new  # Replace with real gateway
      amount_in_cents = (@booking.total_price * 100).to_i

      response = gateway.purchase(amount_in_cents, credit_card)

      if response.success?
        @booking.update(
          status: "confirmed",
          transaction_id: SecureRandom.hex(10)
        )

        # ✅ Trigger email after successful payment
        BookingMailer.booking_confirmation(@booking).deliver_now

        flash[:alert] = "Payment successful! A confirmation email has been sent."
        redirect_to booking_path(@booking)
      else
        flash[:alert] = "Payment failed: #{response.message}"
        redirect_to new_booking_payment_path(@booking)
      end
    else
      flash[:alert] = "Invalid card details. Please try again."
      redirect_to new_booking_payment_path(@booking)
    end
  end
end
