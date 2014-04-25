require 'spec_helper'

describe NodeAttribute do

    it { should respond_to(:name) }
    it { should respond_to(:attr_type) }

 node_attribute = FactoryGirl.create(:node_attribute)
    
    describe "Name" do
     it { node_attribute.name.should_not be_nil }
 end

 describe "Name should be Unique" do
  last_node = NodeAttribute.last
  NodeAttribute.create(name: "#{last_node.name}", attr_type: "DataType")
     it { should_not be_valid }
 end 

 describe "has one creator" do
       create_user_identity
    node_attribute = NodeAttribute.create(name: Faker::Name.first_name, attr_type: "DataType")
    node_attribute.creator = @user
       it { node_attribute.creator.should_not be_nil }
 end
end
