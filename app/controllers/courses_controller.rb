class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy,
                                    :subscribe, :unsubscribe,
                                    :groups, :new_group, :create_group,
                                    :subscribers]
  before_action :authenticate_user!, except: []

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @group = @course.subscribers.where(user: current_user).take.group
  end

  # GET /courses/new
  def new
    @course = Course.new
    authorize @course
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    authorize @course

    @course.instructor = Instructor.where(user: current_user).first

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    authorize @course

    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    authorize @course

    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /courses/:id/subscribe
  def subscribe
    @course.subscribe current_user
    if @course.save
      flash[:alert] = "Successfully subscribed!"
      redirect_to @course
    end
  end

  # DELETE /courses/:id/unsubscribe
  def unsubscribe
    @course.unsubscribe current_user
    flash[:alert] = "Successfully unsubscribed!"
    redirect_to @course
  end

  # GET /courses/:id/groups
  def groups
    @groups = @course.groups
  end

  # GET /courses/:id/groups/new
  def new_group
    @group = Group.new(course: @course)
    authorize @group, :new?
  end

  # POST /courses/:id/groups
  def create_group
    group = Group.new(course: @course,
                      name: params[:group][:name],
                      project_topic: params[:group][:project_topic])
    authorize group, :create?

    if group.save
      flash[:alert] = "Successfully created group!"
      redirect_to group
      return
    else
      flash[:error] = "Failed created group!"
      redirect_to new_group_course_path(@course)
      return
    end
  end


  # GET /courses/:id/subscribers
  def subscribers
    authorize @course, :create?

    @filtered_subscribers = @course.subscribers
    if not params[:name].blank?
      name = params[:name].downcase 
      @filtered_subscribers = @filtered_subscribers.includes(:user)
        .where("LOWER(users.first_name) like ? OR LOWER(users.last_name) like ?", "%#{name}%", "%#{name}%").references(:users)
    end

    if not params[:student_id].blank?
      student_id = params[:student_id].downcase
      @filtered_subscribers = @filtered_subscribers.includes(:user)
        .where("LOWER(users.instituteid) like ?", "%#{student_id}%").references(:users)
    end

    if not params[:course].nil?
      if not params[:course][:group_ids].blank?
        group_id = params[:course][:group_ids]
        @filtered_subscribers = @filtered_subscribers.where(group_id: group_id)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:instructor_id, :name, :start_date, :end_date)
    end
 
    def group_params
      params.require(:group).permit(:course_id, :name, :grade, :project_url)
    end
end
