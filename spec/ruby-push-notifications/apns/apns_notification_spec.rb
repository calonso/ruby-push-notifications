
module RubyPushNotifications
  module APNS
    describe APNSNotification do
      describe '#to_apns_binary' do
        let(:device_token) { '12' }
        let(:data) { { a: 1 } }
        let(:notification) { APNSNotification.new device_token, data }
        let(:notif_id) { 1 }

        it 'successfully creates the apns binary' do
          json = JSON.dump data
          expect(notification.to_apns_binary notif_id).to eq [
            2, 56+json.bytesize, 1, 32, device_token, 2, json.bytesize, json,
            3, 4, notif_id, 4, 4, (Time.now + APNSNotification::WEEKS_4).to_i, 5, 1, 10
          ].pack 'cNcnH64cna*cnNcnNcnc'
        end
      end
    end
  end
end
