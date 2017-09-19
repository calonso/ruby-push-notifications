module RubyPushNotifications
  module WNS
    describe WNSConnection do

      describe '::post' do
        let(:body) { 'abc' }
        let(:headers) {
          {
            'x-wns-notificationstatus' => 'Received',
            'x-wns-deviceconnectionstatus' => 'Connected',
            'x-wns-status' => 'Received'
          }
        }
        let(:push_types) { RubyPushNotifications::WNS::WNSConnection::WP_TARGETS }
        let(:access_token) { 'token' }
        let(:device_urls) { [generate(:wns_device_url)] }
        let(:toast_data) { { title: 'Title', message: 'Hello WNS World!', type: :toast } }
        let(:toast_notification) { build :wns_notification, device_urls: device_urls, data: toast_data }
        let(:wns_connection) { RubyPushNotifications::WNS::WNSConnection }

        before do
          stub_request(:post, %r{hk2.notify.windows.com}).
            to_return status: [200, 'OK'], body: body, headers: headers
        end

        it 'runs the right request' do
          WNSConnection.post toast_notification, access_token
          headers = {
            wns_connection::CONTENT_TYPE_HEADER => wns_connection::CONTENT_TYPE[:toast],
            wns_connection::X_WNS_TYPE_HEADER => wns_connection::WP_TARGETS[:toast],
            wns_connection::CONTENT_LENGTH_HEADER => toast_notification.as_wns_xml.length.to_s,
            wns_connection::AUTHORIZATION_HEADER => "Bearer #{access_token}",
            wns_connection::REQUEST_FOR_STATUS_HEADER => 'true'
          }
          expect(WebMock).
            to have_requested(:post, toast_notification.device_urls[0]).
              with(body: toast_notification.as_wns_xml, headers: headers).
                once
        end

        it 'returns the response encapsulated in a Hash object' do
          responses =  [
            { device_url: toast_notification.device_urls[0],
              headers: headers,
              code: 200
            }
          ]
          expect(WNSConnection.post toast_notification, access_token).to eq WNSResponse.new(responses)
        end
      end

      describe '::access_token' do
        let(:sid) { 'sid' }
        let(:secret) { 'secret' }
        let(:body) {
          "{\"token_type\":\"bearer\",\"access_token\":\"real_access_token\",\"expires_in\":86400}"
        }

        before do
          stub_request(:post, "https://login.live.com/accesstoken.srf").
            to_return status: [200, 'OK'], body: body
        end

        it 'returns access token' do
          expect(WNSConnection.access_token(sid, secret)).to eq('real_access_token')
        end

        context 'when service return an error' do
          let(:body) {
            "{\"error\":\"error\",\"error_description\":\"error_description\"}"
          }

          it 'raise an error' do
            expect { WNSConnection.access_token(sid, secret) }.to \
              raise_error(RubyPushNotifications::WNS::WNSConnection::WNSGetTokenError)
          end
        end
      end
    end
  end
end
