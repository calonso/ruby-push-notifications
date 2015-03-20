FactoryGirl.define do
  factory :apns_notification, class: 'RubyPushNotifications::APNS::APNSNotification' do
    tokens { [generate(:apns_token)] }
    data a: 1

    initialize_with { new tokens, data }
  end
end
