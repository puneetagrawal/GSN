# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity, class: Neo4j::Identity do
  	uid SecureRandom.uuid
    # sequence(:email) { |n| "user_#{n}@example.com" }
  	email "#{Faker::Name.first_name}@gmail.com"  	
    password_confirmation "foobar"
    remember_token SecureRandom.urlsafe_base64
    confirmation_token Neo4j::Identity.hash(Neo4j::Identity.new_random_token)
    confirmation_sent_at Time.now.utc

    factory :provider do
      provider 'normal'
    end  
  end


end
