#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

device_urls = [
  'First device url here',
  'Second device url here'
]

# Notification with toast type
notification = RubyPushNotifications::MPNS::MPNSNotification.new device_urls, { title: 'Title', message: 'Hello MPNS World!', type: 'toast' }

pusher = RubyPushNotifications::MPNS::MPNSPusher.new
pusher.push [notification]
p notification.results
