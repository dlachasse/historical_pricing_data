require_relative './product'

class Response

	attr_reader :response

	def initialize response, type=nil
		@type = type
		@response = response
		build_return_object unless @type.nil?
	end

	def build_return_object
		@results = []
	end

	def delegate current_node=false
		current_node ||= @response
    case current_node
    when Hash
      hash_search current_node
    when Array
      array_search current_node
    end
  end

  def hash_search node
  	handle_error node if node.has_key?("Error")
    delegate node.values[0]
  end

  def array_search node
    node.each do |n| 
    	next if n.has_key?("Error")
      search = Product.new(n["Product"]) if n.has_key?("Product")
      if @type == "check"
        @results << search.sku_offers?
      else
        search.retrieve_values
      end
    end
    collect_results if @results
  end

  def collect_results
  	@results.delete_if { |r| r == false }
  end

  def handle_error node
  	@results << false
    raise "NodeError: #{node[0]['Error']['Message']}"
  end

end