class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def dashboard
    @users = User.all
    @bookings = Booking.all
    @events = Event.includes(:bookings) # Ensure events are loaded
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access Denied!" unless current_user.admin?
  end
end
