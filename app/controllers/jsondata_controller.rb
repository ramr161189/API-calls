class JsondataController < ApplicationController
require 'json'
def wordsdetails
  require 'json'
  file = File.read('/home/student/Desktop/dictionary.json')
  data_hash = JSON.parse(file)
  data_hash.each do |data|
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
  num = rand 133..173
  word = Jsondatum.find(num).word
  Jsondatum.find_each(:batch_size => 10000) do |jsondata|
    if jsondata.word == word
      $data_hash.each do |data|
        if word == data[0]
          $jsonval = data
	  break
          end
        end
     end
  end
  redirect_to '\jsonpage'
end

def randomWord
  apigeneration = Apigeneration.new
  key = String(params[:key])
  apikey = key[1, key.length]
  temp = 0
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey.chomp.casecmp(apikey.chomp) == 0
      val = Integer(apigenerations.usage) + 1
      apigenerations.update(usage: val)
      temp = 1
      id = rand 133..168
      word = Jsondatum.find(id).word
      val = {:word => "#{word}"}
      $jsonval = val.to_json
    end
  end
  redirect_to "/words/randomWord?api_key:#{apikey}"
end

def definitions
  apigeneration = Apigeneration.new
  key = String(params[:key])
  apikey = key[1,key.length]
  wordparam = String(params[:word])
  word=wordparam[1,key.length]
  keystatus = 0
  wordstatus = 0
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey.chomp.casecmp(keyval.chomp) == 0
      val=Integer(apigenerations.usage) + 1
      apigenerations.update(usage: val)
      keystatus = 1
      Jsondatum.find_each(:batch_size => 10000) do |jsondata|
        if jsondata.word == word
          wordstatus = 1
          $data_hash.each do |data|
	  if randomWord==data[0]
	    data.each do |values|
	      if values.class==Hash
	        definition=values["definitions"]
	 	$jsonval=definition
	 	break
	 	end
	      end
	    end
	  end
        end
      end
    end
  end
  if wordstatus == 0
    val = {:error => "WordnotFound"}
    $jsonval = val.to_json
  elsif keystatus == 0
    val = {:error => "APInotFound"}
    $jsonval = val.to_json
  end
  redirect_to "/words/word:#{word}/definitions?api_key:#{apikey}"
end

def examples
  apigeneration = Apigeneration.new
  key = String(params[:key])
  apikey = key[1,key.length]
  wordparam = String(params[:word])
  randomWord = wordparam[1,key.length]
  wordstatus = 0
  apistatus = 0
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey.chomp.casecmp(keyval.chomp) == 0
      val = Integer(apigenerations.usage) + 1
      apigenerations.update(usage: val)
      apistatus = 1
      Jsondatum.find_each(:batch_size => 10000) do |jsondata|
	$data_hash.each do |data|
	  if randomWord == data[0]
	    wordstatus = 1
	    data.each do |values|
	      if values.class == Hash
	 	examples = values["examples"]
	 	$jsonval = examples
	      end	
	    end
	  end
        end
      end
    end
  end
  if wordstatus == 0
    val = {:error => "WordnotFound"}
    $jsonval = val.to_json
  elsif keystatus == 0
    val = {:error => "APInotFound"}
    $jsonval = val.to_json
  end
  redirect_to "/words/word:#{randomWord}/examples?api_key:#{keyval}"
end
	
def relatedWords
  apigeneration=Apigeneration.new
  key = String(params[:key])
  keyval = key[1,key.length]
  wordparam = String(params[:word])
  word = wordparam[1,key.length]
  a = 0
  t = 0
  Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
    if apigenerations.apikey.chomp.casecmp(keyval.chomp) == 0
      val = Integer(apigenerations.usage) + 1
      apigenerations.update(usage: val)
      a = 1
      Jsondatum.find_each(:batch_size => 10000) do |jsondata|
        if jsondata.word == word
          t = 1
	  relatedWords = jsondata.relatedwords
	  val = "@relatedWords are #{relatedWords}@"
	  $jsonval = val.to_json
        end
      end
    end
  end
  if a == 0
    $jsonval = "Keynotfound"
  elsif t==0
    $jsonval = "wordisnotpresent "
  end
  redirect_to '/words/word:{word}/relatedWords?api_key:{keyval}'
end
end
