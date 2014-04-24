require 'spec_helper'

describe NodeAttribute do

    it { should respond_to(:name) }
    it { should respond_to(:attr_type) }

	node_attributes = FactoryGirl.create(:node_attribute)
    # node_attributes = FactoryGirl.create(:node_attribute)
    
    describe "Name" do
    	it { node_attributes.name.should_not be_nil }
	end

	describe "Name should be Unique" do
		count = NodeAttribute.count
		last_node = NodeAttribute.all.map {|o| o}[count-1]
		NodeAttribute.create(name: "#{last_node.name}", attr_type: "DataType")
    	it { should_not be_valid }
	end	
end
