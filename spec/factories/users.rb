# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	uuid SecureRandom.uuid
  	first_name "john"
  	last_name "josh"
  	country "Australia"
  end
end
