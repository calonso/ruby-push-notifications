FactoryGirl.define do
  factory :apns_notification, class: 'RubyPushNotifications::APNS::APNSNotification' do
    tokens { [generate(:apns_token)] }
    data a: 1

    initialize_with { new tokens, data }
  end

  factory :gcm_notification, class: 'RubyPushNotifications::GCM::GCMNotification' do
    registration_ids { [generate(:gcm_registration_id)] }
    data a: 1

    initialize_with { new registration_ids, data }
  end
end
