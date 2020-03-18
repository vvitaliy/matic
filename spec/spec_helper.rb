# frozen_string_literal: true

require 'bundler/setup'
require 'client-api'
require 'csv'
require 'faker'
require 'rest-client'
require 'rspec/expectations'
require 'pry'
require 'json'
require_relative '../lib/functional/_init'
require_relative '../lib/helpers/_init'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.formatter = :documentation
  config.example_status_persistence_file_path = 'results.txt'

  config.before(:all) do
    @app = Matic::Folders.new
  end

  ClientApi.configure do |configure|
    configure.base_url = 'https://testtaskmatic.herokuapp.com'
    configure.headers = { 'Authorization' => 'Bearer 1f43d455fgjkgfjgf48' }
    configure.json_output = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    configure.json_output = {
      'Dirname' => './output',
      'Filename' => Time.now.strftime('%d_%m_%Y__%H_%M_%S__').to_s
    }
    configure.logger = {
      'Dirname' => './logs',
      'Filename' => Time.now.strftime('%d_%m_%Y__%H_%M_%S__').to_s,
      'StoreFilesCount' => 5
    }
    configure.before(:each) do |scenario|
      ClientApi::Request.new(scenario)
    end
  end

  config.include PageInstanceHelper

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
