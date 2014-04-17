# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'



# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123545',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         nickname: "test_twitter",
         first_name: "Test",
         last_name: "Twitter",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '12333dasdasd',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@facebook.com",
         nickname: "test_facebook",
         first_name: "Test",
         last_name: "facebook",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      provider: 'linkedin',
      uid: 'sdadadqwe',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@linkedin.com",
         nickname: "test_linkedin",
         first_name: "Test",
         last_name: "linkedin",
         country: "UK"
      }
    })

OmniAuth.config.mock_auth[:gplus] = OmniAuth::AuthHash.new({
      provider: 'gplus',
      uid: 'qweqwewe',
      credentials:  {
        expires_at:   Time.now + 10.year,
        token:  SecureRandom.urlsafe_base64
      },
      info: {
         email: "test@linkedin.com",
         nickname: "test_linkedin",
         first_name: "Test",
         last_name: "linkedin",
         country: "UK"
      }
    })

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
  

  matchers_path = File.dirname(__FILE__) + "/matchers"
  matchers_files = Dir.entries(matchers_path).select {|x| /\.rb\z/ =~ x}
  matchers_files.each do |path|
    require File.join(matchers_path, path)
  end
  config.include(CustomModelMatchers)

  config.include Capybara::DSL
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
