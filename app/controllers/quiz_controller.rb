class QuizController < ApplicationController
  def index
  	if User.find_by(id: session[:user_id]).name == "admin"
  		redirect_to '/admin'
  	end
  end

  

end
