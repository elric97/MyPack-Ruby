class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    @enrollments = case current_user.role
                   when 'Admin'
                     Enrollment.all
                   when 'Student'
                     Enrollment.where(student_id: current_user.student.id)
                   else
                     Enrollment.where('course_id in (select course_id from courses where instructor_id = ?)',
                                      current_user.instructor.id)
                   end
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  def show_student_enrollments
    @enrollments = Enrollment.where('student_id = ?', current_user.student.id)
  end

  # GET /enrollments/new
  def new
    unless params.key?(:course_id)
      respond_to do |format|
        format.html { redirect_to enrollments_url, notice: 'Please visit courses page for creating new enrollment' }
      end
    end
    @enrollment = Enrollment.new
    @enrollment.course_id = params[:course_id]
  end

  # GET /enrollments/1/edit
  def edit
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "You don't have permission for this" }
      format.json { render :show, status: :created, location: @enrollment }
    end
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.course_id = enrollment_params[:course_id]
    @enrollment.student_id = enrollment_params[:student_id]

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully created.' }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # Checks for permission of the user, if he is allowed to remove a student
  def check_permission?(enrollment)
    is_admin = current_user.role == 'Admin'
    can_delete = if current_user.role == 'Student'
                   current_user.student.can_delete_enrollment?(enrollment.student_id)
                 else
                   current_user.instructor.can_delete_enrollment?(enrollment.course)
                 end

    is_admin || can_delete
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    if !check_permission?(@enrollment)
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "You don't have permission" }
        format.json { head :no_content }
      end
    else
      @waitlists = Waitlist.where(course_id: @enrollment.course_id)

      unless @waitlists.first.nil?
        @waitlists.sort_by(&:created_at)
        @waitlist = @waitlists.first

        @newEnrollment = Enrollment.new(:course_id => @waitlist.course_id, :student_id => @waitlist.student_id)

        @waitlist.destroy

        @newEnrollment.save
      end

      @enrollment.destroy
      respond_to do |format|
        format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:course_id, :student_id)
  end
end
