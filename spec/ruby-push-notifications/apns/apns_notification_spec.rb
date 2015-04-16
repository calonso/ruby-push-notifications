
module RubyPushNotifications
  module APNS
    describe APNSNotification do

      let(:device_tokens) { ['12', '34'] }
      let(:data) { { a: 1 } }
      let(:notification) { APNSNotification.new device_tokens, data }
      let(:notif_id) { 1 }

      it 'successfully creates the apns binary' do
        json = JSON.dump data
        expect do |b|
          notification.each_message notif_id, &b
        end.to yield_successive_args apns_binary(json, device_tokens[0], notif_id), apns_binary(json, device_tokens[1], notif_id+1)
      end

      it 'caches the payload' do
        expect(JSON).to receive(:dump).with(data).once.and_return 'dummy string'
        notification.each_message(notif_id) { }
      end

      it 'validates the data'

      it 'validates the tokens'

      describe 'results management' do
        let(:success_count) { 3 }
        let(:failures_count) { 1 }
        let(:individual_results) {
          [NO_ERROR_STATUS_CODE, PROCESSING_ERROR_STATUS_CODE]
        }
        let(:results) {
          double APNSResults,
            success: success_count,
            failed: failures_count,
            individual_results: individual_results
        }

        before { notification.results = results }

        it 'gives the success count' do
          expect(notification.success).to eq success_count
        end

        it 'gives the failures count' do
          expect(notification.failed).to eq failures_count
        end

        it 'gives the individual results' do
          expect(notification.individual_results).to eq individual_results
        end
      end
    end
  end
end
