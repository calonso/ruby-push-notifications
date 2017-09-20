module RubyPushNotifications
  module WNS
    describe WNSAccess do
      describe '::access_token' do
        let(:sid) { 'sid' }
        let(:secret) { 'secret' }

        context 'when service return status OK' do
          let(:body) {
            "{\"token_type\":\"bearer\",\"access_token\":\"real_access_token\",\"expires_in\":86400}"
          }
          before do
            stub_request(:post, "https://login.live.com/accesstoken.srf").
              to_return status: [200, 'OK'], body: body
          end

          it 'returns correct response' do
            response = OpenStruct.new(
              status_code: 200,
              status: 'OK',
              error: nil,
              error_description: nil,
              access_token: 'real_access_token',
              token_ttl: 86400
            )
            expect(WNSAccess.new(sid, secret).get_token.response).to eq(response)
          end
        end

        context 'when service return an error' do
          context 'when bad credentials' do
            let(:body) {
              "{\"error\":\"invalid_client\",\"error_description\":\"Invalid client id\"}"
            }
            before do
              stub_request(:post, "https://login.live.com/accesstoken.srf").
                to_return status: [400, 'Bad Request'], body: body
            end

            it 'returns correct response' do
              response = OpenStruct.new(
                status_code: 400,
                status: 'Bad Request',
                error: 'invalid_client',
                error_description: 'Invalid client id',
                access_token: nil,
                token_ttl: nil
              )
              expect(WNSAccess.new(sid, secret).get_token.response).to eq(response)
            end
          end

          context 'when bad request' do
            let(:body) { '' }
            before do
              stub_request(:post, "https://login.live.com/accesstoken.srf").
                to_return status: [500, 'Internal Server Error'], body: body
            end

            it 'returns correct response' do
              response = OpenStruct.new(
                status_code: 500,
                status: 'Internal Server Error',
                error: nil,
                error_description: nil,
                access_token: nil,
                token_ttl: nil
              )
              expect(WNSAccess.new(sid, secret).get_token.response).to eq(response)
            end
          end
        end
      end
    end
  end
end
