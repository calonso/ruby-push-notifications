
module RubyPushNotifications
  module GCM
    describe GCMConnection do

      describe '::post' do

        let(:body) { 'abc' }
        let(:key)  { 'def' }
        let(:response) { JSON.dump a: 1 }

        before do
          stub_request(:post, 'https://android.googleapis.com/gcm/send').
            to_return status: [200, 'OK'], body: response
        end

        it 'runs the right request' do
          GCMConnection.post body, key

          expect(WebMock).
            to have_requested(:post, 'https://android.googleapis.com/gcm/send').
              with(body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{key}" }).
                once
        end

        context 'when :url option is present' do
          it 'posts data to a custom GCM endpoint' do
            stub_request(:post, 'https://example.com/gcm/send').
              to_return status: [200, 'OK'], body: response

            GCMConnection.post body, key, url: 'https://example.com/gcm/send'

            expect(WebMock).
              to have_requested(:post, 'https://example.com/gcm/send').
                with(body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{key}" }).
                  once
          end
        end

        it 'returns the response encapsulated in a GCMResponse object' do
          expect(GCMConnection.post body, key).to eq GCMResponse.new(200, response)
        end
      end
    end
  end
end
