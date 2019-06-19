# frozen_string_literal: true

FactoryGirl.define do
  factory :apns_notification,
          class: 'RubyPushNotifications::APNS::APNSNotification' do
    tokens { [generate(:apns_token)] }
    data a: 1

    initialize_with { new tokens, data }
  end

  factory :gcm_notification,
          class: 'RubyPushNotifications::GCM::GCMNotification' do
    registration_ids { [generate(:gcm_registration_id)] }
    data a: 1

    initialize_with { new registration_ids, data }
  end

  factory :fcm_notification,
          class: 'RubyPushNotifications::FCM::FCMNotification' do
    registration_ids { [generate(:fcm_registration_id)] }
    data a:
           {
             'notification': {
               'title': 'Greetings Test',
               'body': 'Remember to test! ALOT!',
               'forceStart': 1,
               'sound': 'default',
               'vibrate': 'true',
               'icon': 'fcm_push_icon'
             },
             'android': {
               'priority': 'high',
               'vibrate': 'true'
             },
             'data': {
               'url': 'https://www.google.com'
             },
             'webpush': {
               'headers': {
                 'TTL': '60'
               }
             },
             'priority': 'high'
           }

    initialize_with { new registration_ids, data }
  end

  factory :mpns_notification,
          class: 'RubyPushNotifications::MPNS::MPNSNotification' do
    device_urls { [generate(:mpns_device_url)] }
    data message: { value1: 'hello' }

    initialize_with { new device_urls, data }
  end

  factory :wns_notification,
          class: 'RubyPushNotifications::WNS::WNSNotification' do
    device_urls { [generate(:wns_device_url)] }
    data message: { value1: 'hello' }

    initialize_with { new device_urls, data }
  end

end
