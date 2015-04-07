
module RubyPushNotifications
  module MPNS
    describe MPNSConnection do

      describe '::post' do

        let(:body) { 'abc' }
        let(:headers) { { 'content-length' => [3] } }
        let(:device_urls) { [generate(:mpns_device_url)] }
        let(:toast_data) { { title: 'Title', message: 'Hello MPNS World!', type: :toast } }
        let(:toast_notification) { build :mpns_notification, device_urls: device_urls, data: toast_data }

        before do
          stub_request(:post, %r{s.notify.live.net}).
            to_return status: [200, 'OK'], body: body, headers: headers
        end

        it 'runs the right request' do
          MPNSConnection.post toast_notification

          expect(WebMock).
            to have_requested(:post, toast_notification.device_urls[0]).
              with(body: toast_notification.as_mpns_xml, headers: { 'Content-Type' => 'text/xml', 'X-NotificationClass' => '2', 'X-WindowsPhone-Target' => :toast}).
                once
        end

        it 'returns the response encapsulated in a Hash object' do
          expect(MPNSConnection.post toast_notification).to eq [
            { device_url: toast_notification.device_urls[0],
              message: 'OK',
              headers: headers,
              status_code: 200
            }
          ]
        end
      end
    end
  end
end
