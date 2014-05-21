require 'time'
require_relative './database'

class Product

	attr_reader :product_object

	def initialize product_object
    @product = product_object
    @fulfillment_channel = nil
    @offer_listings_considered = nil
    @price = nil
    @price_currency = nil
    @local = nil
  end

  def retrieve_values
    find_sku
    get_lowest_offers
  end

  def sku_offers?
    if !@product["Offers"].nil?
    	return_local
    else
    	false
    end
  end

  def return_local
    find_sku
    set_return_type
  	get_lowest_offers "Offers"
  	@sku
  end

  def set_return_type
  	@local = true
  end

  def find_sku
    @sku = @product["Identifiers"]["SKUIdentifier"]["SellerSKU"]
  end

  # LowestOfferListing always represents a new product in response
  # Qualifiers always represents a new offer within a LowestOfferListing
  def get_lowest_offers key="LowestOfferListings"
  	if @product["#{key}"].respond_to?(:map)
	    @product["#{key}"].map { |offer| offer_delegator(offer[1]) }
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
    @fulfillment_channel = @offer.has_key?("Qualifiers") ? @offer["Qualifiers"]["FulfillmentChannel"] : @offer["FulfillmentChannel"]
  end

  def offer_listings_considered
    @offer_listings_considered ||= 0
    @offer_listings_considered += @offer["NumberOfOfferListingsConsidered"].to_i || nil
  end

  def price
  	base_key = @offer.has_key?("Price") ? "Price" : "BuyingPrice"
    @price = @offer["#{base_key}"]["LandedPrice"]["Amount"].to_f
    @price_currency = @offer["#{base_key}"]["LandedPrice"]["CurrencyCode"]
  end

  def send_object
		@db = Database.new
		if @local
  		@db.save_local @sku, stringify(@fulfillment_channel), @price, stringify(@price_currency)
  	else
    	@db.save_competition @sku, stringify(@fulfillment_channel), @offer_listings_considered, @price, stringify(@price_currency)
    end
  end

  def stringify field
  	"'" + field + "'" unless field.nil?
  end

end