#!/usr/bin/env bundle exec ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

registration_ids = [
  'First registration id here',
  'Second registration id here'
]

# Example JSON payload
payload = {
  "notification": {
    "title": "Greetings Test",
    "body": "Remember to test! ALOT!",
    "forceStart": 1,
    "sound": "default",
    "vibrate": "true",
    "icon": "fcm_push_icon"
  },
  "android": {
    "priority": "high",
    "vibrate": "true"
  },
  "data": {
    "url": "https://www.google.com"
  },
  "webpush": {
    "headers": {
      "TTL": "60"
    }
  },
  "priority": "high"
}

notification = RubyPushNotifications::FCM::FCMNotification.new registration_ids, payload

pusher = RubyPushNotifications::FCM::FCMPusher.new "Your app's FCM key"

pusher.push [notification]
p 'Notification sending results:'
p "Success: #{notification.success}, Failed: #{notification.failed}"
p 'Details:'
p notification.individual_results
