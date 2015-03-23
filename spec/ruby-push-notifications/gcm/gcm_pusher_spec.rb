
module RubyPushNotifications
  module GCM
    describe GCMPusher do

      let(:gcm_key) { 'gcm key' }
      let(:pusher) { GCMPusher.new gcm_key }

      describe '#push' do

        let(:notif1) { build :gcm_notification }
        let(:notif2) { build :gcm_notification }

        before do
          stub_request(:post, 'https://android.googleapis.com/gcm/send')
        end

        it 'submits every notification' do
          pusher.push [notif1, notif2]

          expect(WebMock).
            to have_requested(:post, 'https://android.googleapis.com/gcm/send').
              with(body: notif1.as_gcm_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{gcm_key}" }).
                once

          expect(WebMock).
            to have_requested(:post, 'https://android.googleapis.com/gcm/send').
              with(body: notif2.as_gcm_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{gcm_key}" }).
                once
        end

        # According to https://developer.android.com/google/gcm/server-ref.html#table3
        it 'parses errors'

        it 'splits notifications with more than 1000 destinations in parts'

      end
    end
  end
end
