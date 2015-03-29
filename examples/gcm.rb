#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

registration_ids = [
  'First registration id here',
  'Second registration id here'
]

notification = RubyPushNotifications::GCM::GCMNotification.new registration_ids, { text: 'Hello GCM World!' }

pusher = RubyPushNotifications::GCM::GCMPusher.new "Your app's GCM key"
pusher.push [notification]
p notification.results
