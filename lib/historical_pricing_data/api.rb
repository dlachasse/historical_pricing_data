require 'mws-rb'

class Api

	def initialize
		@merchant_id = ENV['MERCHANT_ID']
		@marketplace_id = ENV['MARKETPLACE_ID']
		@aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
		@secret_key = ENV['SECRET_KEY']
		@amazon_url = ENV['AMAZON_URL']
	end

	def connect
		MWS.new(
			host: @amazon_url,
		  aws_access_key_id: @aws_access_key_id,
		  aws_secret_access_key: @secret_key,
		  seller_id: @merchant_id
		)
	end

	def marketplace_id
		@marketplace_id
	end

end