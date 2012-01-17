require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

require "capybara/rspec"
require 'capybara/rails'

Capybara.default_selector = :css
Capybara.javascript_driver = :webkit

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
