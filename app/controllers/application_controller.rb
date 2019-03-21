class ApplicationController < ActionController::Base
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
end
