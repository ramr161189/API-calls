class UsersController < ApplicationController
def index
end
	
def create
  user = User.new(user_params)
  if user.save
    session[:user_id] = user.id
    if user.plan=='basic'
      user.update_columns(maxkey:5)
      user.update_columns(todaylimit:500)
    elsif user.plan=='advance'
      user.update_columns(maxkey:10)
      user.update_columns(todaylimit:1000)
    elsif user.plan=='expert'
      user.update_columns(maxkey:20)
      user.update_columns(todaylimit:2000)
    end
    flash[:notice] = "created successfully"
    redirect_to '/'
   else
     flash[:register_errors] = user.errors.full_messages
     redirect_to '/'
   end
 end
	
private
def user_params
  params.require(:user).permit(:email, :password, :password_confirmation,:plan)
end
end
