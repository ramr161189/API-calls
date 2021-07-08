class JsondataController < ApplicationController
	require 'json'

	def wordsdetails
		require 'json'
		file = File.read('/home/student/Desktop/dictionary.json')
		data_hash = JSON.parse(file)
		data_hash.each do |data|
			json = Jsondatum.new
		 data.each do |values|
	 	json.word=values if values.class==String
	 	if values.class==Hash
	 		 json.definitions=values["definitions"]
	 		json.examples=values["examples"]
	 		json.relatedwords=values["relatedWords"]
	 	end
	 	json.save
	 end
	end
	end	

	def wordofday
		num=rand 133..173
		word=Jsondatum.find(num).word
		Jsondatum.find_each(:batch_size => 10000) do |jsondata|
			if jsondata.word==word
				definition=jsondata.definitions
				examples=jsondata.examples
				relatedWords=jsondata.relatedwords
				$val="word is #{word} +‘\n’ + definition is #{definition} +‘\n’+  examples is #{examples} +‘\n’+  relatedwords are #{relatedWords}\n "
				$jsonval=$val.to_json
				end
			end
		redirect_to '\jsonpage'
	end

	def randomWord
		$val=" "
		$wordcall=1
		apigeneration=Apigeneration.new
		key=String(params[:key])
		apikey=key[1,key.length]
		t=0
		Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
			if apigenerations.apikey.chomp.casecmp(apikey.chomp)==0
				val=Integer(apigenerations.usage)+1
				apigenerations.update(usage: val)
				t=1
				id=rand 133..168
				word=Jsondatum.find(id).word
				$val={:word =>"@Random word is: #{word}@"}
				$jsonval=$val.to_json

			end
		end
		redirect_to '/words/randomWord?api_key:keyval'
	end

	def definitions
		$wordcall=1
		apigeneration=Apigeneration.new
		key=String(params[:key])
		keyval=key[1,key.length]
		wordparam=String(params[:word])
		word=wordparam[1,key.length]
		a=0
		t=0
		Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
			if apigenerations.apikey.chomp.casecmp(keyval.chomp)==0
				val=Integer(apigenerations.usage)+1
				apigenerations.update(usage: val)
				a=1
				Jsondatum.find_each(:batch_size => 10000) do |jsondata|
					if jsondata.word==word
						t=1
						definition=jsondata.definitions
						$val="@definition is #{definition}@"
						$jsonval=$val.to_json
					end
				end
			end
		end
		if t==0
			$jsonval="null"
		elsif a==0
			$val="null"
		end
		redirect_to '/words/word:{word}/definitions?api_key:{keyval}'

	end

	def examples
		$wordcall=1
		apigeneration=Apigeneration.new
		key=String(params[:key])
		keyval=key[1,key.length]
		wordparam=String(params[:word])
		word=wordparam[1,key.length]
		a=0
		t=0
		Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
			if apigenerations.apikey.chomp.casecmp(keyval.chomp)==0
				val=Integer(apigenerations.usage)+1
				apigenerations.update(usage: val)
				a=1
				Jsondatum.find_each(:batch_size => 10000) do |jsondata|
					if jsondata.word==word
						t=1
						examples=jsondata.examples
						$val="examples is"+ examples
						$jsonval=$val.to_json
					end
				end
			end
		end
		if a==0
			$val="Keynotfound"
			
		elsif t==0
			$val="wordisnotpresent "
		end
		redirect_to '/words/word:{word}/examples?api_key:{keyval}'

	end


	def relatedWords
		$wordcall=1
		apigeneration=Apigeneration.new
		key=String(params[:key])
		keyval=key[1,key.length]
		wordparam=String(params[:word])
		word=wordparam[1,key.length]
		a=0
		t=0
		Apigeneration.find_each(:batch_size => 10000) do |apigenerations|
			if apigenerations.apikey.chomp.casecmp(keyval.chomp)==0
				val=Integer(apigenerations.usage)+1
				apigenerations.update(usage: val)
				a=1
				Jsondatum.find_each(:batch_size => 10000) do |jsondata|
					if jsondata.word==word
						t=1
						relatedWords=jsondata.relatedwords
						$val="@relatedWords are #{relatedWords}@"
						$jsonval=$val.to_json
					end
				end
			end
		end
		if a==0
			$val="Keynotfound"
			
		elsif t==0
			$val="wordisnotpresent "
		end
		redirect_to '/words/word:{word}/relatedWords?api_key:{keyval}'

	end


end
