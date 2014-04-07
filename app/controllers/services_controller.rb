class ServicesController < ApplicationController

  def create  
    provider = env["omniauth.auth"].provider
    uid = env["omniauth.auth"].uid
    identity = Neo4j::Identity.find(provider: provider, uid: uid)    
    if identity.blank?       
      identity = from_omniauth(env["omniauth.auth"], current_user)      
    end
    unless identity.errors.any?
      unless signed_in?  
  	  	sign_in(identity, provider)
      end
      
      if identity.user == current_user
        redirect_to identity
      else
        redirect_to root_path, :flash => { :error => "Already associate with an user" }
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

    def from_omniauth(auth, c_user)
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
      
      identity.provider = auth.provider
      identity.uid = auth.uid
      identity.email = (auth.info.email.present?) ? auth.info.email : "#{auth.info.nickname}@#{auth.provider}.com"
      identity.nickname = auth.info.nickname
      identity.oauth_token = auth.credentials.token
      identity.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
      identity.country = country

      if identity.save
        user.identities << identity 
        identity.user = user         
      end
      
      return identity  
    end

end
