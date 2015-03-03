FactoryGirl.define do
  factory :apns_notification, class: 'RubyPushNotifications::APNS::APNSNotification' do
    token { generate :apns_token }
    data a: 1

    initialize_with { new token, data }
  end
end
