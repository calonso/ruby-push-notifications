
module RubyPushNotifications
  module GCM
    describe GCMResponse do

      describe 'success' do

        let(:successful_messages) { 3 }
        let(:failed_messages) { 1 }
        let(:canonical_ids) { 2 }
        let(:body) { JSON.dump(
          multicast_id: 123456789,
          success: successful_messages,
          failure: failed_messages,
          canonical_ids: canonical_ids,
          results: [
            { message_id: 1,
              registration_id: 'new_reg_id' },
            { message_id: 2,
              registration_id: 'new_reg_id_2' },
            { message_id: 3 },
            { message_id: 4,
              error: 'NotRegistered' }
          ]
        ) }

        let(:response) { GCMResponse.new 200, body }

        it 'parses the number of successfully processed notifications' do
          expect(response.success).to eq successful_messages
        end

        it 'parses the number of failed messages' do
          expect(response.failed).to eq failed_messages
        end

        it 'parses the number of canonical ids received' do
          expect(response.canonical_ids).to eq canonical_ids
        end

        it 'parses the results' do
          expect(response.results).to eq [GCMCanonicalIDResult.new('new_reg_id'), GCMCanonicalIDResult.new('new_reg_id_2'), GCMResultOK.new, GCMResultError.new('NotRegistered')]
        end
      end

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
