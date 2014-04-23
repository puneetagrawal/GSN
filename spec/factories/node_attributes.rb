# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node_attribute do
  	name "#{Faker::Name.name}"
  	attr_type "DataType" 
  end
end
