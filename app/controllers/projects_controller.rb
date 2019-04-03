class ProjectsController < ApplicationController

  # POST /groups/:id/project
  def upload_project
    group = Group.find(params[:id])
    authorize group, :show?

    if not current_user.instructor?
      if not group.course.in_training_period? Time.now.to_date
        flash[:alert] = "Can't upload file when not in training period."
        redirect_to group
        return
      end
    end

    group.project.attach(params[:group][:project])
    flash[:alert] = "Successfully uploaded project."
    redirect_to group
  end
  
  # DELETE /groups/:id/project
  def delete_project
    group = Group.find(params[:id])
    authorize group, :show?

    group.project.purge
    flash[:alert] = "Successfully deleted project."
    redirect_to group
  end
end
