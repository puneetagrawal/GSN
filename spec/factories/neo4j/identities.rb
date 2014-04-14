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


    # factory :identity_with_provider do
    #   after(:create) do |identity|        
    #     identity.identity_provider("normal")     
    #   end
    # end

    # factory :identity_with_user do
    #   after(:create) do |identity|        
    #     user.identities << identity
    #     identity.user = user     
    #   end
    # end

  end


end
