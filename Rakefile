require "bundler/gem_tasks"
require_relative './lib/historical_pricing_data'

desc "Download current prices"
task :download do
	HistoricalPricingData.new
end