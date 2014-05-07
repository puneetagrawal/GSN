def create_user_identity
	 @user = FactoryGirl.create(:user)
     @identity = FactoryGirl.create(:identity)
     @user.identities << @identity
     # @identity.user = @user
     @identity.identity_provider("normal")
end