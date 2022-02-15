class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    redirect_to root_path if current_user.role == "Student"
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  def show_student_enrollments
    @enrollments = Enrollment.where('student_id = ?', current_user.student.id)
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
    @enrollment.course_id = params[:course_id]
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.course_id = enrollment_params[:course_id]
    @course = Course.find(enrollment_params[:course_id])
    @course.capacity = @course.capacity - 1
    @enrollment.student_id = enrollment_params[:student_id]
    @course.save

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
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
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
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
