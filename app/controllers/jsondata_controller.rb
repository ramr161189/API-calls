class JsondataController < ApplicationController
  before_action :apikeycheck, only: [:randomWord, :definitions, :examples, :relatedwords]
  before_action :wordcheck, only: [:definitions, :examples, :relatedwords]
  def apikeycheck
    key = String(params[:key])
    $keyval = key[1,key.length]
    apigeneration = Apigeneration.find_by(apikey:$keyval)
    val = Integer(apigeneration.usage)+1
    apigeneration.update(usage: val)
  end

  def wordcheck
    wordparam = String(params[:word])
    $randomWord = wordparam[1,wordparam.length]
    jsondata = Jsondatum.find_by(word:$randomWord)
    $data = jsondata
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
    id = rand 133..168
    word =  Jsondatum.find(id).word
    val = {"word" =>"#{word}"}
    $jsonval = val
    redirect_to "/words/randomWord?api_key:#{$keyval}"
  end

  def definitions
    definition = $data.definitions
    $jsonval = definition
    redirect_to "/words/word:#{$randomWord}/definitions?api_key:#{$keyval}"
  end
	
  def examples
    definition = $data.examples
    $jsonval = definition
    redirect_to "/words/word:#{$randomWord}/examples?api_key:#{$keyval}"
  end

  def relatedWords
    definition = $data.relatedwords
    $jsonval = definition
    redirect_to "/words/word:#{$randomWord}/relatedWords?api_key:#{$keyval}"
  end
end

