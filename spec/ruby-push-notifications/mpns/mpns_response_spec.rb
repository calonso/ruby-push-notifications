
module RubyPushNotifications
  module MPNS
    describe MPNSResponse do

      describe 'success' do

        let(:successful_messages) { 2 }
        let(:failed_messages) { 6 }
        let(:header_success) {
          {
            'X-NotificationStatus' => 'Received',
            'X-DeviceConnectionStatus' => 'Connected',
            'X-SubscriptionStatus' => 'Active'
          }
        }

        let(:responses) {
          [
            { device_url: '1', headers: header_success, code: 200 },
            { device_url: '2', headers: header_success, code: 200 },
            { device_url: '3', code: 400 },
            { device_url: '4', code: 401 },
            { device_url: '5', headers: {}, code: 404 },
            { device_url: '6', headers: {}, code: 406 },
            { device_url: '7', headers: {}, code: 412 },
            { device_url: '8', code: 503 }
          ]
        }

        let(:response) { MPNSResponse.new responses }

        it 'parses the number of successfully processed notifications' do
          expect(response.success).to eq successful_messages
        end

        it 'parses the number of failed messages' do
          expect(response.failed).to eq failed_messages
        end

        it 'parses the results' do
          expect(response.results).to eq [
            MPNSResultOK.new('1', header_success),
            MPNSResultOK.new('2', header_success),
            MalformedMPNSResultError.new('3'),
            MPNSAuthError.new('4'),
            MPNSInvalidError.new('5', {}),
            MPNSLimitError.new('6', {}),
            MPNSPreConditionError.new('7', {}),
            MPNSInternalError.new('8')
          ]
        end
      end
    end
  end
end
