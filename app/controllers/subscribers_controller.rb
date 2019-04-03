class SubscribersController < ApplicationController
  # GET /groups/:id/add_subscriber
  def add_subscribers
    @group = Group.find(params[:id])
    authorize @group, :edit?

    @course = @group.course

    # Subscribers of this course who are students and are not in this group.
    @student_subscribers = @course.subscribers
      .where("group_id !=? or group_id is null", @group.id)
  end

  # PUT /groups/:id/add_subscriber
  def add_subscriber
    group = Group.find(params[:id])
    authorize group, :create?

    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber.group = group

    if subscriber.save
      flash[:alert] = "Successfully added #{subscriber.user.username} to group!"
      redirect_to add_subscribers_group_path(group)
    else
      flash[:error] = "Failed to add to #{subscriber.user.username} group!"
      redirect_to add_subscribers_group_path(group)
    end
  end

  # DELETE /groups/:id/remove_subscriber
  def remove_subscriber
    group = Group.find(params[:id])
    authorize group, :create?

    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber.group = nil

    if subscriber.save
      flash[:alert] = "Successfully removed #{subscriber.user.username} from group!"
      redirect_to group
    else
      flash[:error] = "Failed to remove #{subscriber.user.username} from group!"
      redirect_to group
    end
  end
end
