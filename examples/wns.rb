#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'ruby-push-notifications'

sid = "ms-app://...."
secret = "..."

wns_access = RubyPushNotifications::WNS::WNSAccess.new(sid, secret).get_token
access_token = wns_access.response.access_token

device_urls = ["https://hk2.notify.windows.com/?token=AwYAAACEIPGNfZtVWJMvU%2fJ67TTdLQNdFl2345SbaCP7dmkvUmy6Cv9Y7hM4UT5uA%2b3obnZlIIhQcse9Hs6RPW0MPFVjf3MugnfD8qjIHMtRKIsKENIFveN1xQ6S38m90%2fgaBsE%3d"]

notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :toast, title: 'This is a special title', message: 'this is a special message'})
# notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :tile, image: 'https://res-5.cloudinary.com/prepathon/image/fetch/w_21,h_21,c_fill,g_face/http://assets-cdn.github.com/images/icons/emoji/unicode/1f604.png?v6', message: 'this is a special message'})
# notification = RubyPushNotifications::WNS::WNSNotification.new(device_urls, { type: :badge, value: 'activity'})

pusher = RubyPushNotifications::WNS::WNSPusher.new(access_token)

pusher.push([notification])
p 'Notification sending results:'
p "Success: #{notification.success}, Failed: #{notification.failed}"
p 'Details:'
p notification.individual_results
