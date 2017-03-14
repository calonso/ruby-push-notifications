#!/usr/bin/env bundle exec ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

tokens = [
  'First token here',
  'Second token here'
]
password = nil # optional password for .pem file

notification = RubyPushNotifications::APNS::APNSNotification.new tokens, { aps: { alert: 'Hello APNS World!', sound: 'true', badge: 1 } }

pusher = RubyPushNotifications::APNS::APNSPusher.new(File.read('/path/to/your/apps/certificate.pem'), true, password) # enter the password if present
# Connect timeout defaults to 30s
# pusher = RubyPushNotifications::APNS::APNSPusher.new(File.read('/path/to/your/apps/certificate.pem'), true, password, { connect_timeout: 20 })

# Manually set APNS environment (e.g. useful for load testing)
# When option `host` is given it always uses this environment, `sandbox` param is ignored.
# pusher = RubyPushNotifications::APNS::APNSPusher.new(File.read('/path/to/your/apps/certificate.pem'), true, password, { host: "gateway.push.example.com" })

pusher.push [notification]
p 'Notification sending results:'
p "Success: #{notification.success}, Failed: #{notification.failed}"
p 'Details:'
p notification.individual_results
