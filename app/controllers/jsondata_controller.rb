class JsondataController < ApplicationController
  before_action : apikeycheck, only : [: randomWord, : action]
  before_action :wordcheck, only: [:action]

  def apikeycheck
    key = params[:key]
    apikey = key[1, key.length]
    apigeneration = Apigeneration.find_by(apikey:apikey)
    if apigeneration
      user = User.find_by(email:apigeneration.email)
      if user.count < user.todaylimit
        user.update_columns(count: user.count + 1)
	apigeneration.update_columns(usage:apigeneration.usage + 1)
      else
        render json:{ error:"Today limit is exceeded" }
      end
    else
      render json:{ error:"APIKEY not found" }
    end
  end

  def wordcheck
    word = params[:word]
    @jsondata = Jsondatum.find_by(word:word)
    if !@jsondata
      render json:{ error:"wordnotfound" }
    end
  end

  def wordofday
    id = rand 347..379
    render json:Jsondatum.find(id)
  end

  def randomWord
    id = rand 347..379
    word =  Jsondatum.find(id).word
    render json:{ "word" => "#{word}" }
  end
	
  def action
    action = params[:apiaction]
    if action == 'definitions'
      render json:@jsondata.definitions
    elsif action == 'examples'
      render json:@jsondata.examples
    elsif action == 'relatedWords'
      render json:@jsondata.relatedwords
    else
      render json:{ error:"cannot get #{action} action" }
    end
  end	
end

