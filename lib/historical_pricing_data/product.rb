require 'time'
require_relative './database'

class Product

	attr_reader :product_object

	def initialize product_object
    @product = product_object
    @fulfillment_channel = nil
    @offer_listings_considered = nil
    @lowest_price = nil
    @lowest_price_currency = nil
  end

  def retrieve_values
    find_sku
    get_lowest_offers
  end

  def sku_offers?
    find_sku
    if !@product["Offers"].nil?
    	@sku
    else
    	false
    end
  end

  def find_sku
    @sku = @product["Identifiers"]["SKUIdentifier"]["SellerSKU"]
  end

  # LowestOfferListing always represents a new product in response
  # Qualifiers always represents a new offer within a LowestOfferListing
  def get_lowest_offers
  	if @product["LowestOfferListings"].respond_to?(:map)
	    @product["LowestOfferListings"].map { |offer| offer_delegator(offer[1]) }
	  else
  		send_object
  	end
  end

  def offer_delegator offer
    @offer = offer
    case @offer
    when Hash
      get_offer_results
    when Array
      @offers = @offer
      multi_offer
    end
  end

  def multi_offer
    @offer = @offers[0]
    get_offer_results
  end

  def get_offer_results
    [:find_fulfillment_channel, :offer_listings_considered, :price, :send_object].each { |method| send(method) }
  end

  def find_fulfillment_channel
    @fulfillment_channel = @offer["Qualifiers"]["FulfillmentChannel"]
  end

  def offer_listings_considered
    @offer_listings_considered ||= 0
    @offer_listings_considered += @offer["NumberOfOfferListingsConsidered"].to_i
  end

  def price
    @lowest_price = @offer["Price"]["LandedPrice"]["Amount"].to_f
    @lowest_price_currency = @offer["Price"]["LandedPrice"]["CurrencyCode"]
  end

  def send_object
		@db = Database.new
    @db.save @sku, stringify(@fulfillment_channel), @offer_listings_considered, @lowest_price, stringify(@lowest_price_currency)
  end

  def stringify field
  	"'" + field + "'" unless field.nil?
  end

end