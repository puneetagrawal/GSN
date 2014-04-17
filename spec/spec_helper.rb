require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  matchers_path = File.dirname(__FILE__) + "/matchers"
  matchers_files = Dir.entries(matchers_path).select {|x| /\.rb\z/ =~ x}
  matchers_files.each do |path|
    require File.join(matchers_path, path)
  end
  config.include(CustomModelMatchers)

  config.include Capybara::DSL
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods

  config.order = "random"
  config.color_enabled = true
  config.tty = true
  config.formatter = :documentation # :progress, :html, :textmate
end

end

Spork.each_run do
  
  FactoryGirl.reload
end
