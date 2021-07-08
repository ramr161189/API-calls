class ApigenerationController < ApplicationController
$totalusage = 0
def create
  api_id = apigeneration.id
end
	
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
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey == val
      Apigeneration.delete(apigenerations.id)
      break
    end
 end
  redirect_to '/dashboard'
end

def apikeycheck
  apigeneration = Apigeneration.new
  key = String(params[:key])
  keyval = key[1, key.length]
  temp = 0
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey.chomp.casecmp(keyval.chomp) == 0
      val = Integer(apigenerations.usage) + 1
      apigenerations.update(usage: val)
      temp = 1
      break
    end
  end
  if(temp == 0)
   flash[:alert] = "API key is not present"
  end
  redirect_to '/dashboard'
end
end
