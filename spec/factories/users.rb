FactoryGirl.define do
  factory :user do
   uuid SecureRandom.uuid
   first_name "john"
   last_name "josh"
   country "Australia"

   # factory :user_with_identity do
   #   after(:create) do |user|
   #     identity = FactoryGirl.create(:identity) 
   #     user.identities << identity
   #     identity.user = user

   #   end
   # end

end
end
