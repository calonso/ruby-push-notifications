
module RubyPushNotifications
  module MPNS
    describe MPNSPusher do

      let(:pusher) { MPNSPusher.new }

      describe '#push' do

        let(:device_urls) { [generate(:mpns_device_url)] }
        let(:notif1) { build :mpns_notification, device_urls: ['http://s.notify.live.net/1'],  data: { message: { value1: 'hello' } } }
        let(:notif2) { build :mpns_notification, device_urls: ['http://s.notify.live.net/1'], data: { message: { value1: 'hello' } } }
        let(:raw_notification) { build :mpns_notification }
        let(:toast_data) { { title: 'Title', message: 'Hello MPNS World!', type: :toast } }
        let(:toast_notification) { build :mpns_notification, device_urls: device_urls, data: toast_data }
        let(:tile_data) { { count: 1, title: 'Hello MPNS World!', type: :tile } }
        let(:tile_notification) { build :mpns_notification, device_urls: device_urls, data: tile_data }
        let(:header_success) {
          {
            'x-notificationstatus' => ['Received'],
            'x-deviceconnectionstatus' => ['Connected'],
            'x-subscriptionstatus' => ['Active']
          }
        }
        let(:response) { [ { device_url: 'http://s.notify.live.net/1', headers: header_success, code: 200 } ]}

        before do
          stub_request(:post, %r{s.notify.live.net}).
            to_return status: [200, 'OK'], headers: header_success
        end

        it 'submits every notification' do
          pusher.push [raw_notification, toast_notification, tile_notification]
          expect(WebMock).
            to have_requested(:post, raw_notification.device_urls[0]).
              with(body: raw_notification.as_mpns_xml, headers: { 'Content-Type' => 'text/xml', 'X-NotificationClass' => '3'}).
                once

          expect(WebMock).
            to have_requested(:post, toast_notification.device_urls[0]).
              with(body: toast_notification.as_mpns_xml, headers: { 'Content-Type' => 'text/xml', 'X-NotificationClass' => '2', 'X-WindowsPhone-Target' => :toast}).
                once

          expect(WebMock).
            to have_requested(:post, tile_notification.device_urls[0]).
              with(body: tile_notification.as_mpns_xml, headers: { 'Content-Type' => 'text/xml', 'X-NotificationClass' => '1', 'X-WindowsPhone-Target' => 'token'}).
                once
        end

        it 'sets results to notifications' do
          expect do
            pusher.push [notif1, notif2]
          end.to change { [notif1, notif2].map &:results }.from([nil, nil]).to [MPNSResponse.new(response)]*2
        end

      end
    end
  end
end
