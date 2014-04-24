# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node_attribute do
  	sequence(:name){|n| "#{Faker::Name.first_name}#{n}" }  
  	attr_type "DataType" 
  end
end
