class ApigenerationController < ApplicationController
  
  def add
    user = User.find(session[: user_id])
    if user.apikeycount < user.maxkey
      apigeneration = Apigeneration.new
      apigeneration.apikey = SecureRandom.uuid
      apigeneration.usage = 0
      apigeneration.email = user.email
      user.update_columns(apikeycount :user.apikeycount + 1)
      apigeneration.save
    else
      flash[:notice] = "maxkeysover"
    end
    redirect_to '/dashboard'
  end
		
  def delete
    val = params[:my_params]
    Apigeneration.where(apikey: val ).delete_all
    user = User.find(session[: user_id])
    user.update_columns(apikeycount: user.apikeycount - 1)
    redirect_to '/dashboard'
  end
	
end
