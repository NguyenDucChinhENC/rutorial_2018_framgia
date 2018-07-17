class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: downcase_email
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t(".email_activate")
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".flash.wrong_password_email_login"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def downcase_email
    params[:session][:email].downcase
  end
end
