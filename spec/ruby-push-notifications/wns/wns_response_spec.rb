module RubyPushNotifications
  module WNS
    describe WNSResponse do

      describe 'success' do

        let(:successful_messages) { 2 }
        let(:failed_messages) { 7 }
        let(:headers) {
          {
            'x-wns-notificationstatus' => 'Received',
            'x-wns-deviceconnectionstatus' => 'Connected',
            'x-wns-status' => 'Received'
          }
        }

        let(:responses) {
          [
            { device_url: '1', headers: headers, code: 200 },
            { device_url: '2', headers: headers, code: 200 },
            { device_url: '3', code: 400 },
            { device_url: '4', code: 401 },
            { device_url: '5', headers: headers, code: 404 },
            { device_url: '6', headers: headers, code: 406 },
            { device_url: '7', headers: headers, code: 412 },
            { device_url: '8', code: 503 },
            { device_url: '9', headers: headers, code: 410 }
          ]
        }

        let(:response) { WNSResponse.new responses }
        let(:result) { WNSResultOK.new '1', headers }

        it 'parses the number of successfully processed notifications' do
          expect(response.success).to eq successful_messages
        end

        it 'parses the number of failed messages' do
          expect(response.failed).to eq failed_messages
        end

        it 'parses the results' do
          expect(response.results).to eq [
            WNSResultOK.new('1', headers),
            WNSResultOK.new('2', headers),
            MalformedWNSResultError.new('3'),
            WNSAuthError.new('4'),
            WNSInvalidError.new('5', headers),
            WNSLimitError.new('6', headers),
            WNSPreConditionError.new('7', headers),
            WNSInternalError.new('8'),
            WNSExpiredError.new('9', headers)
          ]
        end

        it 'parses headers to result attributes' do
          expect(result.notification_status).to eq 'Received'
          expect(result.device_connection_status).to eq 'Connected'
          expect(result.status).to eq 'Received'
        end

      end
    end
  end
end
