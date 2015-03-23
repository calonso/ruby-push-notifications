
module RubyPushNotifications
  module GCM
    describe GCMNotification do

      let(:registration_ids) { %w(a b c) }
      let(:data) { { a: 1 } }
      let(:notification) { build :gcm_notification, registration_ids: registration_ids, data: data }

      it 'builds the right gcm json' do
        expect(notification.to_gcm_json).to eq(
          registration_ids: registration_ids,
          data: data
        )
      end

      it 'validates the registration_ids format'

      # According to https://developer.android.com/google/gcm/server-ref.html#table1
      it 'validates the data'

    end
  end
end
