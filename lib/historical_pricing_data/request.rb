require_relative './api'
require_relative './response'
require 'pp'

class Request < Api

	def initialize
		@api = Api.new
		@db = Database.new
		@mws = @api.connect
		@active_sku_list = []
		request_our_price
		request_competitive_prices
	end

	def sku_list
		@db.retreive_licensed_skus
	end

	def request_competitive_prices
		@active_sku_list.each_slice(9) do |s|
			skus = build_sku_list s
			response = @mws.products.get_lowest_offer_listings_for_SKU(skus)
			output = Response.new(response.parsed_response).delegate
		end
	end

	def request_our_price
		sku_list.each_slice(9) do |s|
			skus = build_sku_list s
			response = @mws.products.get_my_price_for_SKU(skus)
			result = Response.new(response.parsed_response, "check").delegate
			result.map { |active_sku| @active_sku_list << active_sku } unless result.nil?
		end
	end

	def build_sku_list skus
		@out = ""
		skus.each_with_index do |sku, i|
			@out << "'SellerSKUList.SellerSKU.#{i + 1}' => '#{sku}',"
		end
		@out.insert(-1, " 'MarketplaceId' => '#{@api.marketplace_id}'")
		eval("{#{@out}}")
	end

end