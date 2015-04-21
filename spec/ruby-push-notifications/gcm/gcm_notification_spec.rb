
module RubyPushNotifications
  module GCM
    describe GCMNotification do

      let(:registration_ids) { %w(a b c) }
      let(:data) { { a: 1 } }
      let(:notification) { build :gcm_notification, registration_ids: registration_ids, data: data }

      it 'builds the right gcm json' do
        expect(notification.as_gcm_json).to eq JSON.dump(
          registration_ids: registration_ids,
          data: data
        )
      end

      it 'validates the registration_ids format'

      # According to https://developer.android.com/google/gcm/server-ref.html#table1
      it 'validates the data'

      it_behaves_like 'a proper results manager' do
        let(:success_count) { 2 }
        let(:failures_count) { 1 }
        let(:canonical_id) { 'abcd' }
        let(:individual_results) { [GCMCanonicalIDResult.new(canonical_id)] }
        let(:results) do
          GCMResponse.new 200, JSON.dump(
            success: success_count, failure: failures_count, results: [
              registration_id: canonical_id
            ]
            )
        end
      end
    end
  end
end
