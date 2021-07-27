class JsondataController < ApplicationController
  before_action :apikeycheck, only: [:randomWord, :definitions, :examples, :relatedWords]
  before_action :wordcheck, only: [:definitions, :examples, :relatedWords]

  def apikeycheck
    key = params[:key]
    apikey = key[1,key.length]
    apigeneration = Apigeneration.find_by(apikey:apikey)
    if apigeneration
      user=User.find_by(email:apigeneration.email)
      if user.count < user.todaylimit
	      user.update_columns(count: user.count + 1)
	      apigeneration.update_columns(usage:apigeneration.usage + 1)
      else
        render json:{error:"Today limit is exceeded"}
      end
    else
      render json:{error:"APIKEY not found"}
    end
  end

  def wordcheck
    wordparam = params[:word]
    randomWord = wordparam[1,wordparam.length]
    @jsondata = Jsondatum.find_by(word:randomWord)
    if !@jsondata
      render json:{error:"wordnotfound"}
    end
  end

  def wordofday
    id = rand 347..379
    render json:Jsondatum.find(id)
  end

  def randomWord
    id = rand 347..379
    word =  Jsondatum.find(id).word
    render json:{"word" =>"#{word}"}
  end

  def definitions
    render json:@jsondata.definitions
  end
	
  def examples
    render json:@jsondata.examples
  end

  def relatedWords
   render json:@jsondata.relatedwords
  end
end

