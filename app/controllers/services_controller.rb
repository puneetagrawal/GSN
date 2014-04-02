class ServicesController < ApplicationController

  def create  
    provider = env["omniauth.auth"].provider
    uid = env["omniauth.auth"].uid
    identity = Neo4j::Identity.find(provider: provider, uid: uid)
    if identity.blank?    
      identity = from_omniauth(env["omniauth.auth"], current_user)      
    end

    if signed_in?         
	    redirect_to identity 
	  else
	  	sign_in(identity, provider)
	  end      
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  private

    def from_omniauth(auth, c_user)
      user = if c_user.present?
                c_user
             else
               User.create(first_name: auth.info.first_name,
                           last_name: auth.info.last_name                         
                           ) 
              end

     
      identity = Neo4j::Identity.new
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.email = if auth.info.email ? auth.info.email : "#{auth.info.nickname}@#{auth.provider}"
      identity.nickname = auth.info.nickname
      identity.oauth_token = auth.credentials.token
      identity.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at

      if identity.save
        user.identities << identity 
        identity.user = user         
      end      
      return identity  
    end

end
