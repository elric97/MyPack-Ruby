class StudentsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  skip_before_action :role_assigned, only: [:new, :create]
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    case current_user.role
    when 'Admin'
      @students = Student.all
    when 'Student'
      @students = Student.where('user_id = ?', current_user.id)
    else
      redirect_to root_path
    end
  end

  # GET /students/1 or /students/1.json
  def show
    unless current_user.can_crud?(@student.user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # GET /students/new
  def new
    @student = Student.new
    @student.user_id = if current_user.role != 'Admin'
                         current_user.id
                       else
                         params[:user_id]
                       end
  end

  # GET /students/1/edit
  def edit
    unless current_user.can_crud?(@student.user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    @user = User.find(@student.user_id)
    @user.role = 'Student'
    @user.save

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:studentID, :DOB, :phone, :major, :email_address, :password, :user_id, :name)
    end
end
