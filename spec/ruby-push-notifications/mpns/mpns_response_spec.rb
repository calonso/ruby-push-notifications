
module RubyPushNotifications
  module MPNS
    describe MPNSResponse do

      describe 'success' do

        let(:successful_messages) { 2 }
        let(:failed_messages) { 6 }
        let(:headers) {
          {
            'x-notificationstatus' => 'Received',
            'x-deviceconnectionstatus' => 'Connected',
            'x-subscriptionstatus' => 'Active'
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
            { device_url: '8', code: 503 }
          ]
        }

        let(:response) { MPNSResponse.new responses }
        let(:result) { MPNSResultOK.new '1', headers }

        it 'parses the number of successfully processed notifications' do
          expect(response.success).to eq successful_messages
        end

        it 'parses the number of failed messages' do
          expect(response.failed).to eq failed_messages
        end

        it 'parses the results' do
          expect(response.results).to eq [
            MPNSResultOK.new('1', headers),
            MPNSResultOK.new('2', headers),
            MalformedMPNSResultError.new('3'),
            MPNSAuthError.new('4'),
            MPNSInvalidError.new('5', headers),
            MPNSLimitError.new('6', headers),
            MPNSPreConditionError.new('7', headers),
            MPNSInternalError.new('8')
          ]
        end

        it 'parses headers to result attributes' do
          expect(result.notification_status).to eq 'Received'
          expect(result.device_connection_status).to eq 'Connected'
          expect(result.subscription_status).to eq 'Active'
        end

      end
    end
  end
end
