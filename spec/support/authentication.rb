include SessionsHelper

def user_sign_in(identity = create(:identity))
  identity.confirmed?
  sign_in identity, 'normal'
end

def user_sign_out
  current_identity = identity
  sign_out 
end

def request_sign_in(identity = create(:identity))
  request_sign_out

  visit signin_path
  within '#main-login-form' do
    fill_in 'Email', with: identity.email
    fill_in 'Password', with: identity.password
    click_button 'Sign in'
  end
end

def request_sign_out
  visit signout_path
end