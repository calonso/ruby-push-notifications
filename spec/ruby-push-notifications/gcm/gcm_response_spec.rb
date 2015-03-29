
module RubyPushNotifications
  module GCM
    describe GCMResponse do

      describe 'errors' do
        let(:dummy_response_body) { 'dummy response body' }
        describe '400 Bad Request error code' do
          it 'raises a MalformedGCMJSONError' do
            expect do
              GCMResponse.new 400, dummy_response_body
            end.to raise_error MalformedGCMJSONError, dummy_response_body
          end
        end

        describe '401 Unauthorized error code' do
          it 'raises a GCMAuthError' do
            expect do
              GCMResponse.new 401, dummy_response_body
            end.to raise_error GCMAuthError, dummy_response_body
          end
        end

        describe '500 Internal Server Error error code' do
          it 'raises a GCMInternalError' do
            expect do
              GCMResponse.new 500, dummy_response_body
            end.to raise_error GCMInternalError, dummy_response_body
          end
        end

        describe '302 Found error code' do
          it 'raises a UnexpectedGCMResponseError' do
            expect do
              GCMResponse.new 302, dummy_response_body
            end.to raise_error UnexpectedGCMResponseError, '302'
          end
        end
      end
    end
  end
end
