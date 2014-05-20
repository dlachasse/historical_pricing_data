require 'dotenv'
Dotenv.load('../.env')

require_relative 'historical_pricing_data/api'
require_relative 'historical_pricing_data/version'
require_relative 'historical_pricing_data/database'
require_relative 'historical_pricing_data/request'
require_relative 'historical_pricing_data/response'
require_relative 'historical_pricing_data/product'

module HistoricalPricingData

	def self.new
		Request.new
	end

end

