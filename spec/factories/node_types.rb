# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node_type do
  	sequence(:field_name){|n| "#{Faker::Name.first_name}#{n}" }   	
  end
end
