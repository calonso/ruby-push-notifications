# frozen_string_literal: true

module RubyPushNotifications
  module FCM
    describe FCMConnection do
      describe '::post' do
        let(:body) { 'abc' }
        let(:key) { 'def' }
        let(:response) { JSON.dump a: 1 }

        before do
          stub_request(:post,
                       'https://fcm.googleapis.com/fcm/send'
          ).to_return status: [200, 'OK'], body: response
        end
        it 'runs the right request' do
          FCMConnection.post body, key

          expect(WebMock).to have_requested(
                               :post,
                               'https://fcm.googleapis.com/fcm/send')
                               .with(body: body,
                                     headers:
                                       { 'Content-Type' => 'application/json',
                                         'Authorization' => "key=#{key}"
                                       }
                               ).once
        end

        context 'when :url option is present' do
          it 'posts data to a custom FCM endpoint' do
            stub_request(:post, 'https://example.com/fcm/send').
              to_return status: [200, 'OK'], body: response

            FCMConnection.post body, key, url: 'https://example.com/fcm/send'

            expect(WebMock).
              to have_requested(:post,
                                'https://example.com/fcm/send').
                with(body: body,
                     headers: { 'Content-Type' => 'application/json',
                                'Authorization' => "key=#{key}" }).
                once
          end
        end

        it 'returns the response encapsulated in a FCMResponse object' do
          expect(FCMConnection.post(body, key)).to eq FCMResponse.new(200,
                                                                      response)
        end
      end
    end
  end
end
