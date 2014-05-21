require 'tiny_tds'
require 'time'

class Database

	def initialize
		@client = TinyTds::Client.new(
			:host => ENV['DB_HOST'],
			:port => ENV['DB_PORT'].to_i,
			:username => ENV['DB_USERNAME'],
			:password => ENV['DB_PASSWORD'],
			:timeout => ENV['DB_TIMEOUT'].to_i,
			:tds_version => ENV['DB_TDS_VERSION'].to_i)
		@time = Time.now.iso8601
	end

	def retreive_licensed_skus
		sql = "SELECT LocalSKU FROM [SE Data].dbo.Inventory
		WHERE Category = 'Licensed Shirts'"
		result = @client.execute sql
		parse(result, "LocalSKU")
	end

	def parse result, field
		result.map { |f| f[field] }
	end

	def insert
		result = @client.execute @sql
		result.insert
	end

	def save_competition sku, fulfillment_channel=nil, number_of_offers=nil, low_price=nil, low_price_currency=nil
		@sql = "INSERT INTO [SE Data].dbo.CompetitivePricingHistory (LocalSKU, #{'FulfillmentChannel, ' unless fulfillment_channel.nil? }#{'OfferListingsConsidered, ' unless number_of_offers.nil? }#{'LowestPrice, ' unless low_price.nil? }#{'LowestPriceCurrency, ' unless low_price_currency.nil? }Time) VALUES ('#{sku}', #{fulfillment_channel + ', ' unless fulfillment_channel.nil? }#{number_of_offers.to_s + ', ' unless number_of_offers.nil?}#{low_price.to_s + ', ' unless low_price.nil? }#{low_price_currency + ', ' unless low_price_currency.nil? }'#{@time}')"
		insert
	end

	def save_local sku, fulfillment_channel=nil, price=nil, price_currency=nil
		@sql = "INSERT INTO [SE Data].dbo.OurPricingHistory (LocalSKU, #{'FulfillmentChannel, ' unless fulfillment_channel.nil? }#{'OurPrice, ' unless price.nil? }#{'OurPriceCurrency, ' unless price_currency.nil? }Time) VALUES ('#{sku}', #{'dbo.fProperCase(' + fulfillment_channel + ', null, null), ' unless fulfillment_channel.nil? }#{price.to_s + ', ' unless price.nil? }#{price_currency + ', ' unless price_currency.nil? }'#{@time}')"
		insert
	end

end