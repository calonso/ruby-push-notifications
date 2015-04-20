
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

      describe 'results management' do

        let(:success_count) { 2 }
        let(:failed_count) { 1 }
        let(:canonical_id) { 'abcd' }
        let(:individual_results) { [GCMCanonicalIDResult.new(canonical_id)] }
        let(:results) {
          GCMResponse.new 200, JSON.dump(
            success: success_count, failure: failed_count, results: [
              registration_id: canonical_id
            ]
            )
        }

        before { notification.results = results }

        it 'gives the success count' do
          expect(notification.success).to eq success_count
        end

        it 'gives the failures count' do
          expect(notification.failed).to eq failed_count
        end

        it 'gives the individual results' do
          expect(notification.individual_results).to eq individual_results
        end
      end
    end
  end
end
