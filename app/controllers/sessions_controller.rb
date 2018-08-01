class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
    if session[:user_id]
      print "Already Logged In"
    end
  end

  def create
  	user = User.find_by(name: params[:name])
    if user and user.name=="admin" and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
  	elsif user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		redirect_to quiz_url
  	else
  		redirect_to login_url, alert:"Invalid Username or Password"
  	end
  end

  def destroy
    if session[:user_id]
  	 session[:user_id] = nil
  	 redirect_to login_url
    else
     redirect_to login_url
   end
  end
  
end
