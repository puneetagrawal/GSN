class SessionsController < ApplicationController

  def new
  end

  def create    
    identity = Neo4j::Identity.find(email: params[:session][:email].downcase)
    
    if identity && Neo4j::Identity.encrypt_password(identity.email, params[:session][:password]) == identity.password
      # Sign the user in and redirect to the user's show page.
      sign_in(identity, "normal")
      redirect_to identity
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  	sign_out
    redirect_to root_url
  end

  def confirm_user
    identity = Neo4j::Identity.find(confirmation_token: params[:token])    
    if identity.present?
      identity.confirmed_at = Time.now
      identity.confirmation_token = ""
      identity.save
      sign_in(identity, "normal")
      redirect_to identity
    else
      redirect_to root_path, notice: "Token is invalid"
    end
  end
end
