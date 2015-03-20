
module RubyPushNotifications
  module APNS
    describe APNSNotification do
      describe 'building messages for each token' do

        let(:device_tokens) { ['12', '34'] }
        let(:data) { { a: 1 } }
        let(:notification) { APNSNotification.new device_tokens, data }
        let(:notif_id) { 1 }

        it 'successfully creates the apns binary' do
          json = JSON.dump data
          expect do |b|
            notification.each_message notif_id, &b
          end.to yield_successive_args [apns_binary(json, device_tokens[0], notif_id), notif_id], [apns_binary(json, device_tokens[1], notif_id+1), notif_id+1]
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
