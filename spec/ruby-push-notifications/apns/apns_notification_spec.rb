
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
        end.to yield_successive_args apns_binary(json, device_tokens[0], notif_id), apns_binary(json, device_tokens[1], notif_id + 1)
      end

      it 'caches the payload' do
        allow(data).to receive(:respond_to?).and_return(false)
        expect(JSON).to receive(:dump).with(data).once.and_return 'dummy string'
        notification.each_message(notif_id) {}
      end

      it 'validates the data'

      it 'validates the tokens'

      it_behaves_like 'a proper results manager' do
        let(:success_count) { 2 }
        let(:failures_count) { 1 }
        let(:individual_results) do
          [
            NO_ERROR_STATUS_CODE,
            PROCESSING_ERROR_STATUS_CODE,
            NO_ERROR_STATUS_CODE
          ]
        end
        let(:results) { APNSResults.new individual_results }
      end
    end
  end
end
