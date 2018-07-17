class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.kaminari_per
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".flash.welcome"
      redirect_to @user
    else
      flash[:error] = t ".flash.error"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user&.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:error] = t ".delete_error"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "plz_login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if current_user? @user
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
