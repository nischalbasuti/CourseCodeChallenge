class GroupsController < ApplicationController
  before_action :set_group, except: [:index, :create, :new]
  before_action :authenticate_user!, except: []

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize @group
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  # GET /groups/1/edit
  def edit
    authorize @group
  end

  # PUT /groups/1/update_name
  def update_name
    if @group.has_user? current_user
      @group.name = params[:group][:name]

      if @group.save
        flash[:alert] = "Successfully updated name of group to #{params[:name]}."
      else
        flash[:error] = "Failed to update the name of the group."
      end
      redirect_to @group
    else
      flash[:error] = "You must be a member of the group to update it's name."
      redirect_to @group
    end
  end

  # GET /groups/1/edit_name
  def edit_name
  end

  # GET /groups/1/edit_project_topic
  def edit_project_topic
    authorize @group, :create?
  end

  # PUT /groups/1/update_project_topic
  def update_project_topic
    authorize @group, :create?

    @group.project_topic = params[:group][:project_topic]

    if @group.save
      flash[:alert] = "Successfully updated project topic."
    else
      flash[:error] = "Failed to update the project topic."
    end
    redirect_to @group
  end

  # GET /groups/1/edit_grade
  def edit_grade
  end

  # PUT /groups/1/update_grade
  def update_grade
    # TODO before_action set_group not working, find out why.
    @grade = Group.find(params[:id]) # Temporary fix for before_action problem.
    authorize @grade, :create?

    @group.grade = params[:group][:grade]

    if @group.save
      flash[:alert] = "Successfully updated grade."
    else
      flash[:error] = "Failed to update grade."
    end
    redirect_to @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    authorize @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    authorize @group
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /groups/:id/add_subscriber
  def add_subscribers
    authorize @group, :edit?

    @course = @group.course

    # Subscribers of this course who are students and are not in this group.
    @student_subscribers = @course.subscribers
                          .where("group_id !=? or group_id is null", @group.id)
                          .includes(:user).where(users: {role: Role.find(1)})
  end

  # PUT /groups/:id/add_subscriber
  def add_subscriber
    authorize @group, :create?

    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber.group = @group

    if not subscriber.user.student?
      flash[:error] = "Only students can be added to a group!"
      redirect_to add_subscribers_group_path(@group)
      return
    end

    if subscriber.save
      flash[:alert] = "Successfully added #{subscriber.user.username} to group!"
      redirect_to add_subscribers_group_path(@group)
    else
      flash[:error] = "Failed to add to #{subscriber.user.username} group!"
      redirect_to add_subscribers_group_path(@group)
    end
  end

  # DELETE /groups/:id/remove_subscriber
  def remove_subscriber
    authorize @group, :create?

    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber.group = nil

    if subscriber.save
      flash[:alert] = "Successfully removed #{subscriber.user.username} from group!"
      redirect_to @group
    else
      flash[:error] = "Failed to remove #{subscriber.user.username} from group!"
      redirect_to @group
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:course_id, :name, :grade, :project_url)
    end
end
