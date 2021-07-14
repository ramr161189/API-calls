class ApigenerationController < ApplicationController
def add
  apigeneration = Apigeneration.new
  apigeneration.apikey = SecureRandom.uuid
  apigeneration.usage = 0
  apigeneration.email = $username
  apigeneration.save
  redirect_to '/dashboard'
end
	
def delete
  val = params[: my_params]
  Apigeneration.where(apikey:val ).delete_all
  redirect_to '/dashboard'
end
end
