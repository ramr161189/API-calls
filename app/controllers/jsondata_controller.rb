class JsondataController < ApplicationController
  before_action :apikeycheck, only: [:randomWord, :definitions, :examples, :relatedWords]
  before_action :wordcheck, only: [:definitions, :examples, :relatedWords]
  def apikeycheck
    username = User.find(session[:user_id]).email
    if User.find_by(email:username).count < $apicalls
      key = String(params[:key])
      @keyval = key[1,key.length]
      @apigeneration = Apigeneration.find_by(apikey:@keyval)
      if @apigeneration
        @apigeneration.update(usage: Integer(@apigeneration.usage) + 1)
	user = User.find_by(email:username)
        user.update_columns(count: Integer(user.count) + 1)			
      end     
    else
      flash[:notice] = "LimitExceeded." 
      redirect_to '/dashboard'
    end
  end

  def wordcheck
    if @apigeneration
      wordparam = String(params[:word])
      @randomWord = wordparam[1,wordparam.length]
      @jsondata = Jsondatum.find_by(word:@randomWord)
  end

  def wordofday
    num = rand 133..168
    jsondata = Jsondatum.find(num)
    $jsonval = jsondata.definitions + jsondata.examples + jsondata.relatedwords
    redirect_to '\jsondata'
  end

  def randomWord
    if @apigeneration  
      id = rand 133..168
      word =  Jsondatum.find(id).word
      val = {"word" =>"#{word}"}
      $jsonval = val
    else
      $jsonval = {"error" => "APIKEYNotFound"}
    end
    redirect_to "/words/randomWord?api_key:#{@keyval}"
  end

  def definitions
    if @jsondata && @apigeneration
      $jsonval = @jsondata.definitions
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{@randomWord}/definitions?api_key:#{@keyval}"
  end
	
  def examples
    if @jsondata && @apigeneration
      $jsonval = @jsondata.examples
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{@randomWord}/examples?api_key:#{@keyval}"
  end

  def relatedWords
   if @jsondata && @apigeneration
      $jsonval = @jsondata.relatedWords
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{@randomWord}/relatedWords?api_key:#{@keyval}"
  end
end

