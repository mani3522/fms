class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:notice] = 'Success Login' # Not quite right!
      redirect_to user,:notice => "Logged in!"
    else

      flash[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'

    end
  end

  def destroy
    flash[:notice] = "Logged Out"
    session[:user_id] = nil
    redirect_to login_url
  end
end
