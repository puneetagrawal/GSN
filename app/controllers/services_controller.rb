class ServicesController < ApplicationController

  def create 
    auth = env["omniauth.auth"] 
    provider = auth.provider
    email = (auth.info.email.present?) ? auth.info.email : "#{auth.info.nickname}@#{auth.provider}.com"
    oauth_token = auth.credentials.token
    oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
   
    identity = Neo4j::Identity.find(email: email)    
    if identity.blank?       
      identity = from_omniauth(auth, current_user, email)      
    end

    identity.identity_provider(provider, auth.uid, oauth_token, oauth_expires_at)

    unless identity.errors.any?
      unless signed_in?  
  	  	sign_in(identity, provider)
      end
      
      if identity.user == current_user
        redirect_to identity
      else
        redirect_to root_path
      end
    else
      redirect_to root_path, :flash => { :error => show_error_messages(identity) }
    end          
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  private

    def from_omniauth(auth, c_user, email)
      country = auth.info.location.split(',')[1].strip if auth.info.location.present?
      user = if c_user.present?
                c_user
             else
               User.create(first_name: auth.info.first_name,
                           last_name: auth.info.last_name,                         
                           country: country                         
                           ) 
              end

     
      identity = Neo4j::Identity.new
      
      # identity.provider = auth.provider
      # identity.uid = auth.uid
      identity.email = email
      identity.nickname = auth.info.nickname     
      identity.country = country

      if identity.save
        user.identities << identity 
        identity.user = user         
      end
      
      return identity  
    end

end
