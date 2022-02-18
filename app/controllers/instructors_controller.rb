class InstructorsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  skip_before_action :role_assigned, only: [:new, :create]
  before_action :set_instructor, only: %i[ show edit update destroy ]

  # GET /instructors or /instructors.json
  def index
    case current_user.role
    when 'Admin'
      @instructors = Instructor.all
    when 'Instructor'
      @instructors = Instructor.where('user_id = ?', current_user.id)
    else
      redirect_to root_path
    end
  end

  def showInstructorCourses
    @courses = Course.show(current_user.id)
  end
  # GET /instructors/1 or /instructors/1.json
  def show
    unless current_user.can_crud?(@instructor.user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
    @instructor.user_id = if current_user.role != 'Admin'
                         current_user.id
                       else
                         params[:user_id]
                       end
  end

  # GET /instructors/1/edit
  def edit
    unless current_user.can_crud?(@instructor.user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # POST /instructors or /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)

    @user = User.find(@instructor.user_id)
    @user.role = "Instructor"

    respond_to do |format|
      if @instructor.save
        @user.save
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

  def check_role
    if !current_user.role.nil? && current_user.role == 'Student'
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Not authorised to view this." }
        format.json { head :no_content }
      end
    end
  end

    # Only allow a list of trusted parameters through.
  def instructor_params
    params.require(:instructor).permit(:department, :user_id)
  end
end
