class InstructorsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  skip_before_action :role_assigned, only: [:new, :create]
  before_action :set_instructor, only: %i[ show edit update destroy ]

  # GET /instructors or /instructors.json
  def index
    @instructors = Instructor.where('user_id = ?', current_user.id)
  end

  def showInstructorCourses
    @courses = Course.show(current_user.id)
  end
  # GET /instructors/1 or /instructors/1.json
  def show
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
  end

  # GET /instructors/1/edit
  def edit
  end

  # POST /instructors or /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)
    @instructor.user_id = current_user.id

    @user = current_user
    @user.role = "Instructor"
    @user.save

    respond_to do |format|
      if @instructor.save
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully created." }
        format.json { render :show, status: :created, location: @instructor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1 or /instructors/1.json
  def update
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.html { redirect_to instructor_url(@instructor), notice: "Instructor was successfully updated." }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instructors/1 or /instructors/1.json
  def destroy
    puts "Checking destroy"
    @instructor.destroy

    respond_to do |format|
      format.html { redirect_to instructors_url, notice: "Instructor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def instructor_params
      params.require(:instructor).permit(:department)
    end
end
