
module RubyPushNotifications
  module MPNS

    # This class encapsulates a response received from the MPNS service
    # and helps parsing and understanding the received messages/codes.
    #
    class MPNSResponse

      # @return [Integer] the number of successfully sent notifications
      attr_reader :success

      # @return [Integer] the number of failed notifications
      attr_reader :failed

      # @return [Array] Array of a MPNSResult for every receiver of the notification
      #   sent indicating the result of the operation.
      attr_reader :results

      # Initializes the MPNSResponse and runs response parsing
      #
      # @param code [responses]. The HTTP status code received
      def initialize(responses)
        parse_response responses
      end

      def ==(other)
        (other.is_a?(MPNSResponse) &&
          success == other.success &&
          failed == other.failed &&
          results == other.results) || super(other)
      end

      private

      # Parses the response extracting counts for successful, failed messages.
      # Also creates the results array assigning a MPNSResult subclass for each
      # device URL the notification was sent to.
      #
      # @param responses [Array]. Array of hash responses
      def parse_response(responses)
        @success = count_sucess(responses)
        @failed = count_failed(responses)
        @results = responses.map { |result|
          mpns_result_for result[:code],
                          result[:device_url],
                          result[:headers]
        }
      end

      # Factory method that, for each MPNS result object assigns a MPNSResult
      # subclass.
      #
      # @param code [Integer]. The HTTP status code received
      # @param device_url [String]. The receiver's MPNS device url.
      # @param headers [Hash]. The response headers received.
      # @return [MPNSResult]. Corresponding MPNSResult subclass
      def mpns_result_for(code, device_url, headers)
        case code
        when 200
          MPNSResultOK.new device_url, headers
        when 400
          MalformedMPNSResultError.new device_url
        when 401
          MPNSAuthError.new device_url
        when 404
          MPNSInvalidError.new device_url, headers
        when 406
          MPNSLimitError.new device_url, headers
        when 412
          MPNSPreConditionError.new device_url, headers
        when 500..599
          MPNSInternalError.new device_url
        else
          MPNSResultError.new device_url
        end
      end

      # Method that count sucess responses.
      #
      # @param responses [Hash]. MPNS responses hash
      # @return [Integer]. Number of sucess responses.
      def count_sucess(responses)
        counter = 0
        responses.each do |response|
          counter += 1 if response[:code] == 200
        end
        counter
      end

      # Method that count failed responses.
      #
      # @param responses [Hash]. MPNS responses hash
      # @return [Integer]. Number of failed responses.
      def count_failed(responses)
        counter = 0
        responses.each do |response|
          counter += 1 if response[:code] != 200
        end
        counter
      end

    end
  end
end
