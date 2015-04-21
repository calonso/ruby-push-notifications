#!/usr/bin/env bundle exec ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

registration_ids = [
  'First registration id here',
  'Second registration id here'
]

notification = RubyPushNotifications::GCM::GCMNotification.new registration_ids, { text: 'Hello GCM World!' }

pusher = RubyPushNotifications::GCM::GCMPusher.new "Your app's GCM key"
pusher.push [notification]
p 'Notification sending results:'
p "Success: #{notification.success}, Failed: #{notification.failed}"
p 'Details:'
p notification.individual_results
