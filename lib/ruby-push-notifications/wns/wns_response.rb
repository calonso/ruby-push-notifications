module RubyPushNotifications
  module WNS

    # This class encapsulates a response received from the WNS service
    # and helps parsing and understanding the received messages/codes.
    #
    class WNSResponse

      # @return [Integer] the number of successfully sent notifications
      attr_reader :success

      # @return [Integer] the number of failed notifications
      attr_reader :failed

      # @return [Array] Array of a WNSResult for every receiver of the notification
      #   sent indicating the result of the operation.
      attr_reader :results
      alias_method :individual_results, :results

      # Initializes the WNSResponse and runs response parsing
      #
      # @param responses [Array]. Array with device_urls and http responses
      def initialize(responses)
        parse_response responses
      end

      def ==(other)
        (other.is_a?(WNSResponse) &&
          success == other.success &&
          failed == other.failed &&
          results == other.results) || super(other)
      end

      private

      # Parses the response extracting counts for successful, failed messages.
      # Also creates the results array assigning a WNSResult subclass for each
      # device URL the notification was sent to.
      #
      # @param responses [Array]. Array of hash responses
      def parse_response(responses)
        @success = responses.count { |response| response[:code] == 200 }
        @failed = responses.count { |response| response[:code] != 200 }
        @results = responses.map do |response|
          wns_result_for response[:code],
                          response[:device_url],
                          response[:headers]
        end
      end

      # Factory method that, for each WNS result object assigns a WNSResult
      # subclass.
      #
      # @param code [Integer]. The HTTP status code received
      # @param device_url [String]. The receiver's WNS device url.
      # @param headers [Hash]. The HTTP headers received.
      # @return [WNSResult]. Corresponding WNSResult subclass
      def wns_result_for(code, device_url, headers)
        case code
        when 200
          WNSResultOK.new device_url, headers
        when 400
          MalformedWNSResultError.new device_url
        when 401
          WNSAuthError.new device_url
        when 404
          WNSInvalidError.new device_url, headers
        when 406
          WNSLimitError.new device_url, headers
        when 410
          WNSExpiredError.new device_url, headers
        when 412
          WNSPreConditionError.new device_url, headers
        when 500..599
          WNSInternalError.new device_url
        else
          WNSResultError.new device_url
        end
      end

    end
  end
end
