# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    role_id = params[:user][:role_id]
    if role_id.blank?
      flash[:error] = "Invalid role specified."
      redirect_to "/users/sign_up"
      return
    end
    role = Role.find(role_id)

    instituteid = params[:user][:instituteid]

    # Create a instructor user.
    if role.name == "instructor"
      department_id = params[:instructor][:department_id]

      # Checking if instituteid parameter exists.
      if instituteid.blank?
        flash[:error] = "need to specify instructor id"
        redirect_to "/users/sign_up"
        return
      end

      # Checking if department_id parameter exists.
      if department_id.blank?
        flash[:error] = "need to specify department"
        redirect_to "/users/sign_up"
        return
      end
      # checking if department exists
      department = Department.find(department_id)
      if department.nil?
        flash[:error] = "Could not find department with id #{department_id}"
        redirect_to "/users/sign_up"
        return
      end

      # Create the user as devise normally would.
      super

      # Add user and department to Instructor table.
      instructor = Instructor.new
      instructor.user = resource
      instructor.department = department
      instructor.save
      return
    end

    # Create a student user.
    if role.name == "student"
      # Checking if instituteid parameter exists.
      if instituteid.blank?
        flash[:error] = "need to specify student id"
        redirect_to "/users/sign_up"
        return
      end

      # Create the user as devise normally would.
      super
      return
    end

    # Create a other user.
    if role.name == "other"
      super
    end
  end


  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
