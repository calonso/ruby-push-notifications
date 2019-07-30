# frozen_string_literal: true

module RubyPushNotifications
  module FCM
    describe FCMNotification do
      let(:registration_ids) { %w[a] }
      let(:data) {
        {
          a: {
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
        }
      }
      let(:notification) {
        build :fcm_notification,
              registration_ids: registration_ids,
              data: data
      }

      it 'builds the right fcm json' do
        expect(notification.as_fcm_json).to include(JSON.dump(
          { registration_ids: registration_ids }.merge(data))
                                            )
      end

      it 'validates the registration_ids format'

      # According to
      # https://developer.android.com/google/fcm/server-ref.html#table1
      it 'validates the data'

      it_behaves_like 'a proper results manager' do
        let(:success_count) { 2 }
        let(:failures_count) { 1 }
        let(:canonical_id) { 'abcd' }
        let(:individual_results) { [FCMCanonicalIDResult.new(canonical_id)] }
        let(:results) do
          FCMResponse.new 200, JSON.dump(
            success: success_count,
            failure: failures_count,
            results: [
              registration_id: canonical_id
            ]
          )
        end
      end
    end
  end
end
