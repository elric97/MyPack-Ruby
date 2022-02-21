class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]
  skip_before_action :role_assigned, only: [:new, :create]
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = case current_user.role
             when 'Admin'
               User.all
             else
               User.where(id: current_user.id)
             end
  end

  # GET /users/1 or /users/1.json
  def show
    unless current_user.can_crud?(@user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless current_user.can_crud?(@user)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You are not allowed access to this page.' }
      end
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if !current_user.can_destroy?(@user)
      respond_to do |format|
        format.html { redirect_to users_path, alert: 'Permission Denied: User cannot be destroyed' }
        format.json { head :no_content }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # Assign roles to users
  def assign_new_roles
    if current_user.can_assign_roles?
      @users = User.where('role is NULL')
    else
      raise_error
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil? || !current_user.can_crud?(@user)
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'Not authorised to view this' }
        format.json { head :no_content }
      end
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def raise_error
    @user = User.new
    @user.errors.add(:base, 'You are not authorized to view this !')
    respond_to do |format|
      format.html { render :index, status: :unauthorized }
      format.json { render json: @user.errors, status: :unauthorized }
    end
  end
end
