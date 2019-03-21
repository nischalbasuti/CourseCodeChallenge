class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  # TODO if user is an instructor and his department is not set, redirect to
  # page where the user can set his department.

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:username, :first_name,
                                                     :last_name, :role_id,
                                                     :instituteid, :citizenid ])
    devise_parameter_sanitizer.permit(:account_update, keys:[:username, :first_name,
                                                     :last_name, :role_id,
                                                     :instituteid, :citizenid ])
    devise_parameter_sanitizer.permit(:sign_in, keys:[:username])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
