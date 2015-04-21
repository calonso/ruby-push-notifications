module RubyPushNotifications
  module APNS
    # This class is responsible for holding and
    # managing result of a pushed notification.
    #
    # @author Carlos Alonso
    class APNSResults

      # @return [Array] of each destination's individual result.
      attr_reader :individual_results

      # Initializes the result
      #
      # @param [Array] containing each destination's individual result.
      def initialize(results)
        @individual_results = results
      end

      # @return [Integer] numer of successfully pushed notifications
      def success
        @success ||= individual_results.count { |r| r == NO_ERROR_STATUS_CODE }
      end

      # @return [Integer] number of failed notifications
      def failed
        @failed ||= individual_results.count { |r| r != NO_ERROR_STATUS_CODE }
      end
    end
  end
end
