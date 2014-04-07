# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity, class: Neo4j::Identity do
  	uid SecureRandom.uuid
  	email "test#{Time.now.to_i}@gmail.com"  	
  	nickname "abc"
  	password "foobar"
    password_confirmation "foobar"
    remember_token SecureRandom.urlsafe_base64
    confirmation_token Neo4j::Identity.hash(Neo4j::Identity.new_random_token)
    confirmation_sent_at Time.now.utc
  end
end
