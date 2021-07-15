class JsondataController < ApplicationController
  before_action :apikeycheck, only: [:randomWord, :definitions, :examples, :relatedwords]
  before_action :wordcheck, only: [:definitions, :examples, :relatedwords]
  def apikeycheck
    if User.find_by(email:$username).count < $apicalls
      key = String(params[:key])
      @keyval = key[1,key.length]
      @apigeneration = Apigeneration.find_by(apikey:@keyval)
      if @apigeneration
        val = Integer(@apigeneration.usage) + 1
        @apigeneration.update(usage: val)
	user = User.find_by(email:$username)
	countval = Integer(user.count) + 1
	user.update(count: countval)			
      end      
    else
      format.html{redirect_to '/dashboard',notice: 'APIcalls Limit exceeded'}
    end
  end

  def wordcheck
    if @apigeneration
      wordparam = String(params[:word])
      @randomWord = wordparam[1,wordparam.length]
      @jsondata = Jsondatum.find_by(word:$randomWord)
      if @jsondata
        @data = @jsondata
      end
    end
  end

  def wordsdetails
    require 'json'
    file = File.read('/home/student/Desktop/dictionary.json')
    $data_hash = JSON.parse(file)
    $data_hash.each do |data|
      json = Jsondatum.new
      data.each do |values|
        json.word = values if values.class == String
	if values.class == Hash
	  json.definitions = values["definitions"]
	  json.examples = values["examples"]
	  json.relatedwords = values["relatedWords"]
	end
	json.save
      end
    end
  end	

  def wordofday
    num = rand 133..168
    jsondata = Jsondatum.find(num)
    $jsonval = jsondata.definitions + jsondata.examples + jsondata.relatedwords
    redirect_to '\jsonpage'
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
    if @jsondata
      definition = @data.definitions
      $jsonval = definition
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/definitions?api_key:#{@keyval}"
  end
	
  def examples
    if @jsondata
      examples = @data.examples
      $jsonval = examples
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/examples?api_key:#{@keyval}"
  end

  def relatedWords
   if @jsondata
      relatedWords = @data.relatedWords
      $jsonval = relatedWords
    elsif @apigeneration
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/relatedWords?api_key:#{@keyval}"
  end
end

