require 'spec_helper'

describe Request do

	let(:request) { Request.new }
	subject(:request)

	it { should behave_like Api }

end