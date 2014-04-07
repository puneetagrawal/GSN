require 'spec_helper'

describe Neo4j::Identity do   

  	it { should respond_to(:uid) }
  	it { should respond_to(:email) }
  	it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
  	it { should respond_to(:nickname) }
    
     user = FactoryGirl.create(:user) 
     identity = FactoryGirl.create(:identity) 
     user.identities << identity
     identity.user = user
   
  	describe "UUID" do
    	it { identity.uid.should_not be_nil }
    end

	describe "email" do
    	it { identity.email.should_not be_nil }
	end
	
	
	describe "nickname" do
    	it { identity.nickname.should_not be_nil }
	end
  
  
  describe "when email address is already taken" do
    before do     
      identity_with_same_email = identity.dup
      identity_with_same_email.save
    end
    it { should_not be_valid }
  end

	 
  describe "password " do
    before do
      identity = Neo4j::Identity.new(nickname: "example_user", email: "use223r@example.com", password: " ", password_confirmation: " ", uid: SecureRandom.uuid)
    end
    it { should_not be_blank }
  end

  describe "password mismatch " do
    before { identity.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "password too short" do
    before { identity.password = identity.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
end

