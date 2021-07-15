class JsondataController < ApplicationController
  before_action :apikeycheck, only: [:randomWord, :definitions, :examples, :relatedwords]
  before_action :wordcheck, only: [:definitions, :examples, :relatedwords]
  def apikeycheck
    if $totalapicalls < $apicalls
      key = String(params[:key])
      $keyval = key[1,key.length]
      apigeneration = Apigeneration.find_by(apikey:$keyval)
      if apigeneration
        val = Integer(apigeneration.usage)+1
        apigeneration.update(usage: val)
	@k=1
      else
        @k=0
      end      
    else
      format.html{redirect_to '/dashboard',notice: 'APIcalls Limit exceeded'}
  end

  def wordcheck
    @w=0
    if @k==1
      wordparam = String(params[:word])
      @randomWord = wordparam[1,wordparam.length]
      jsondata = Jsondatum.find_by(word:$randomWord)
      if jsondata
        @w=1	  
        @data = jsondata
      end
    else
      $jsonval = {"error" => "APIKEYNotFound"}
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
    if @k==1	  
      id = rand 133..168
      word =  Jsondatum.find(id).word
      val = {"word" =>"#{word}"}
      $jsonval = val
    else
      $jsonval = {"error" => "APIKEYNotFound"}
    end
    redirect_to "/words/randomWord?api_key:#{$keyval}"
  end

  def definitions
    if @w==1
      definition = @data.definitions
      $jsonval = definition
    elsif @w==0 && @k==1
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/definitions?api_key:#{$keyval}"
  end
	
  def examples
    if @w==1
      examples = @data.examples
      $jsonval = examples
    elsif @w==0 && @k==1
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/examples?api_key:#{$keyval}"
  end

  def relatedWords
   if @w==1
      relatedWords = @data.relatedWords
      $jsonval = relatedWords
    elsif @w==0 && @k==1
      $jsonval = {"error" => "wordnotfound"}
    else
      $jsonval = {"error" => "APIKEYNotfound"}
    end
    redirect_to "/words/word:#{$randomWord}/relatedWords?api_key:#{$keyval}"
  end
end

