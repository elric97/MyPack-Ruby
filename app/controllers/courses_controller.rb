class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = if !current_user.id.nil? && current_user.role == 'Instructor'
                 Course.where(instructor_id: current_user.instructor.id)
               else
                 Course.all
               end
    @courses.each do |course|
      @enrollment =  Enrollment.where(course_id: course.id)
      @waitlist = Waitlist.where(course_id: course.id)
      if course.capacity - @enrollment.count > 0
        course.status = 'Open'
      elsif  course.capacity - @enrollment.count <= 0 && course.wlCapacity - @waitlist.count >0
        course.status = 'Waitlist'

      elsif  course.capacity - @enrollment.count <= 0 && course.wlCapacity - @waitlist.count <= 0
        course.status = 'Closed'
      end
      course.save
    end


  end

  # GET /courses/1 or /courses/1.json
  def show
    if current_user.role == 'Admin' ||
       (current_user.role == 'Instructor' && @course.instructor_id == current_user.instructor.id)
      @enrollments = @course.enrollments
      @waitlists = @course.waitlists
    end
  end

    # GET /courses/new
  def new
    @course = Course.new
    @course.instructor_id = if current_user.role == 'Instructor'
                              current_user.instructor.id
                            else
                              params[:instructor_id]
                            end

  end


  # GET /courses/1/edit
  def edit
    unless can_destroy?(@course)
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Permission denied: You don\'t have permission to do this' }
        format.json { head :no_content }
      end
    end
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.status = 'Open'
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.can_update_cap?(course_params[:capacity]) &&
         @course.can_update_wlcap?(course_params[:wlCapacity]) && @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    if !can_destroy?(@course)
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Permission denied: You don\'t have permission to do this' }
        format.json { head :no_content }
      end
    else
      @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find_by(id: params[:id])
    if @course.nil?
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Not authorised to view this' }
        format.json { head :no_content }
      end
    end
  end

  def can_destroy?(course)
    current_user.role == 'Admin' ||
      (current_user.role == 'Instructor' && current_user.instructor.id == course.instructor_id)
  end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :weekday1, :weekday2, :startTime, :endTime, :courseCode, :capacity, :wlCapacity, :status, :roomNumber, :instructor_id)
    end
end
