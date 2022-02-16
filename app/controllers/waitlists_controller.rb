class WaitlistsController < ApplicationController
  before_action :set_waitlist, only: %i[ show edit update destroy ]

  # GET /waitlists or /waitlists.json
  def index
    redirect_to root_path if current_user.role == "Student"
    @waitlists = Waitlist.all

  end

  # GET /waitlists/1 or /waitlists/1.json
  def show
  end

  def show_student_waitlists
    @waitlists = Waitlist.where('student_id = ?', current_user.student.id)
  end
  # GET /waitlists/new
  def new
    @waitlist = Waitlist.new
    @waitlist.course_id = params[:course_id]

  end

  # GET /waitlists/1/edit
  def edit
  end

  # POST /waitlists or /waitlists.json
  def create
    @waitlist = Waitlist.new(waitlist_params)
    @waitlist.course_id = waitlist_params[:course_id]
    @waitlist.student_id = waitlist_params[:student_id]





    respond_to do |format|
      if @waitlist.save
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully created." }
        format.json { render :show, status: :created, location: @waitlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waitlists/1 or /waitlists/1.json
  def update
    respond_to do |format|
      if @waitlist.update(waitlist_params)
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully updated." }
        format.json { render :show, status: :ok, location: @waitlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waitlists/1 or /waitlists/1.json
  def destroy
    @waitlist.destroy

    respond_to do |format|
      format.html { redirect_to waitlists_url, notice: "Waitlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waitlist
      @waitlist = Waitlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def waitlist_params
      params.require(:waitlist).permit(:course_id, :student_id)
    end
end
