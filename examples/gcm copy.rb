#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

registration_ids = [
  'APA91bFrtpS1bEo4BtTjE3V-GvRTX6KATZmh3ZGZ-wrQVY5UvsuQ4F-UmShwwjiG4uY0qtXG0RS4Tq2ir6t7gN6ziU7fpb1HtuiUKpdkY6WpE38mCxTa7cNeotIGgaKXOdNTEV10GU6Txp-Oxakqavuga6SrYNoVyA',
  'APA91bFwufZkwhPhhLlQyIbM3MUksfxSvXXmXRP9L8LrJ8RMvUbRExERKHAzDR_pXZryKYICuqdS18fiytmks0WmKTZFd9_5AR8nK_m-5djqzM7AfBOyyv7Hy1uWCunJ2FcAbapGfaFYOTaW3MQGxjUIav_8Wj1R0OYANVMvZNGSDcu_j5wA80Y'
]

notification = RubyPushNotifications::GCM::GCMNotification.new registration_ids, { text: 'Hello GCM World!' }

pusher = RubyPushNotifications::GCM::GCMPusher.new 'AIzaSyAEO2CE_ipX217WwWsbHvGr8fiVHDdKUIc'
pusher.push [notification]
p notification.results
