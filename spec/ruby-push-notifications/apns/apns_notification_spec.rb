
module RubyPushNotifications
  module APNS
    describe APNSNotification do
      describe 'building messages for each token' do

        def apns_encode(json, token, id)
          [
            2, 56+json.bytesize, 1, 32, token, 2, json.bytesize, json,
            3, 4, id, 4, 4, (Time.now + APNSNotification::WEEKS_4).to_i, 5, 1, 10
          ].pack 'cNcnH64cna*cnNcnNcnc'
        end

        let(:device_tokens) { ['12', '34'] }
        let(:data) { { a: 1 } }
        let(:notification) { APNSNotification.new device_tokens, data }
        let(:notif_id) { 1 }

        it 'successfully creates the apns binary' do
          json = JSON.dump data
          expect do |b|
            notification.each_message notif_id, &b
          end.to yield_successive_args apns_encode(json, device_tokens[0], notif_id), apns_encode(json, device_tokens[1], notif_id+1)
        end

        it 'caches the payload' do
          expect(JSON).to receive(:dump).with(data).once.and_return 'dummy string'
          notification.each_message(notif_id) { }
        end

        it 'validates the data'

        it 'validates the tokens'
      end
    end
  end
end
