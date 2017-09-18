#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

access_token = "token"

device_urls = ["https://hk2.notify.windows.com/?token=AwYAAADQfhbwpXp8qVJpO%2bTkrJvQkeOIB60V7KBJZfHhSHWVopCkER70pGX0amtKWW9WQeukKTKW%2fuf0hM5%2fC3AQl9EwkjZOpL2LYaRdHOZ5OoRHdxjX3DAuBWu481nFGqlGuaE%3d"]

notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :toast, title: 'This is a special title', message: 'this is a special message'})
# notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :tile, image: 'https://res-5.cloudinary.com/prepathon/image/fetch/w_21,h_21,c_fill,g_face/http://assets-cdn.github.com/images/icons/emoji/unicode/1f604.png?v6', message: 'this is a special message'})
# notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :badge, value: 'activity'})

pusher = RubyPushNotifications::WNS::WNSPusher.new(access_token)

pusher.push([notification])
p 'Notification sending results:'
p "Success: #{notification.success}, Failed: #{notification.failed}"
p 'Details:'
p notification.individual_results
