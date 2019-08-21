# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :defaults, :development
require 'webmock/rspec'

require 'ruby-push-notifications'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

def apns_binary(json, token, id)
  json = JSON.dump(json) if json.is_a?(Hash)
  [
    2, 56 + json.bytesize, 1, 32, token, 2, json.bytesize, json,
    3, 4, id, 4, 4, (Time.now + RubyPushNotifications::APNS::APNSNotification::WEEKS_4).to_i, 5, 1, 10
  ].pack 'cNcnH64cna*cnNcnNcnc'
end

WebMock.disable_net_connect!(:allow => "codeclimate.com")
