
module RubyPushNotifications
  module GCM
    class GCMResponse

      attr_reader :success, :failed, :canonical_ids, :results

      def initialize(code, body)
        case code
        when 200
          parse_response body
        when 400
          raise MalformedGCMJSONError, body
        when 401
          raise GCMAuthError, body
        when 500..599
          raise GCMInternalError, body
        else
          raise UnexpectedGCMResponseError, code
        end
      end

      def ==(other)
        (other.is_a?(GCMResponse) &&
          success == other.success &&
          failed == other.failed &&
          canonical_ids == other.canonical_ids &&
          results == other.results) || super(other)
      end

      private

      def parse_response(body)
        json = JSON.parse body, symbolize_names: true
        @success = json[:success]
        @failed = json[:failure]
        @canonical_ids = json[:canonical_ids]
        @results = (json[:results] || []).map { |result| gcm_result_for result }
      end

      def gcm_result_for(result)
        if canonical_id = result[:registration_id]
          GCMCanonicalIDResult.new canonical_id
        elsif error = result[:error]
          GCMResultError.new error
        else
          GCMResultOK.new
        end
      end
    end
  end
end
