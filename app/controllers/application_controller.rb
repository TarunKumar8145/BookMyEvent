class ApplicationController < ActionController::Base
  private

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path  # Redirects to the login page after logout
  end
end
