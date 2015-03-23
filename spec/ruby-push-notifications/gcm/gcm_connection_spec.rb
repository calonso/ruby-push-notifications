
module RubyPushNotifications
  module GCM
    describe GCMConnection do

      describe '::post' do

        let(:body) { 'abc' }
        let(:key)  { 'def' }

        before do
          stub_request(:post, 'https://android.googleapis.com/gcm/send').
            to_return status: [200, 'OK'], body: 'The body'
        end

        it 'runs the right request' do
          GCMConnection.post body, key

          expect(WebMock).
            to have_requested(:post, 'https://android.googleapis.com/gcm/send').
              with(body: body, headers: { 'Content-Type' => 'application/json', 'Authorization' => "key=#{key}" }).
                once
        end

        it 'returns the response code' do
          expect(GCMConnection.post body, key).to eq(
            code: '200',
            body: 'The body'
            )
        end
      end
    end
  end
end
