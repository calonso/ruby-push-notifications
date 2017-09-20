module RubyPushNotifications
  module WNS
    describe WNSPusher do
      let(:access_token) { 'token' }
      let(:pusher) { WNSPusher.new(access_token) }

      describe '#push' do
        let(:device_urls) { [generate(:wns_device_url)] }
        let(:notifications) { build_list(:wns_notification, 2, device_urls: ['http://hk2.notify.windows.com/1'], data: { message: { value1: 'hello' } }).to_a }
        let(:raw_notification) { build :wns_notification }
        let(:toast_data) { { title: 'Title', message: 'Hello WNS World!', type: :toast } }
        let(:toast_notification) { build :wns_notification, device_urls: device_urls, data: toast_data }
        let(:tile_data) { { message: 'Hello WNS World!', image: 'http://image.com/image.jpg', type: :tile } }
        let(:tile_notification) { build :wns_notification, device_urls: device_urls, data: tile_data }
        let(:badge_data) { { value: 10, type: :badge } }
        let(:badge_notification) { build :wns_notification, device_urls: device_urls, data: badge_data }

        let(:headers) {
          {
            'x-wns-notificationstatus' => 'Received',
            'x-wns-deviceconnectionstatus' => 'Connected',
            'x-wns-status' => 'Received'
          }
        }
        let(:wns_connection) { RubyPushNotifications::WNS::WNSConnection }
        let(:response) { [ { device_url: 'http://hk2.notify.windows.com/1', headers: headers, code: 200 } ]}

        before do
          stub_request(:post, %r{hk2.notify.windows.com}).
            to_return status: [200, 'OK'], headers: headers
        end

        it 'submits every notification' do
          pusher.push [raw_notification, toast_notification, tile_notification, badge_notification]
          %i(raw toast tile badge).each do |push_type|
            headers = {
              wns_connection::CONTENT_TYPE_HEADER => wns_connection::CONTENT_TYPE[push_type],
              wns_connection::X_WNS_TYPE_HEADER => wns_connection::WP_TARGETS[push_type],
              wns_connection::CONTENT_LENGTH_HEADER => public_send("#{push_type}_notification").as_wns_xml.length.to_s,
              wns_connection::AUTHORIZATION_HEADER => "Bearer #{access_token}",
              wns_connection::REQUEST_FOR_STATUS_HEADER => 'true'
            }
            expect(WebMock).
              to have_requested(:post, public_send("#{push_type}_notification").device_urls[0]).
                with(body: public_send("#{push_type}_notification").as_wns_xml, headers: headers).
                  once
          end
        end

        it 'sets results to notifications' do
          expect do
            pusher.push notifications
          end.to change { notifications.map(&:results) }.from([nil, nil]).to [WNSResponse.new(response)] * 2
        end
      end
    end
  end
end
