# frozen_string_literal: true

module RubyPushNotifications
  module FCM
    describe FCMPusher do

      let(:fcm_key) { 'fcm key' }
      let(:pusher) { FCMPusher.new fcm_key }

      describe '#push' do

        let(:notif1) { build :fcm_notification }
        let(:notif2) { build :fcm_notification }
        let(:response) { JSON.dump a: 1 }

        before do
          stub_request(:post, 'https://fcm.googleapis.com/fcm/send').
            to_return status: [200, 'OK'], body: response
        end

        it 'submits every notification' do
          pusher.push [notif1, notif2]

          expect(WebMock).
            to have_requested(:post, 'https://fcm.googleapis.com/fcm/send').
              with(body: notif1.as_fcm_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{fcm_key}" }).
                once

          expect(WebMock).
            to have_requested(:post, 'https://fcm.googleapis.com/fcm/send').
              with(body: notif2.as_fcm_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{fcm_key}" }).
                once
        end

        it 'sets results to notifications' do
          expect do
            pusher.push [notif1, notif2]
          end.to change { [notif1, notif2].map &:results }.from([nil, nil]).to [FCMResponse.new(200, response)]*2
        end

        it 'splits notifications with more than 1000 destinations in parts'

      end
    end
  end
end
