
module RubyPushNotifications
  module GCM
    # Class that encapsulates the result of a single sent notification to a single
    # Registration ID
    # (https://developer.android.com/google/gcm/server-ref.html#table4)
    # @author Carlos Alonso
    class GCMResult ; end

    # Indicates that the notification was successfully sent to the corresponding
    # registration ID
    class GCMResultOK < GCMResult

      def ==(other)
        other.is_a?(GCMResultOK) || super(other)
      end
    end

    # Indicates that the notification was successfully sent to the corresponding
    # registration ID but GCM sent a canonical ID for it, so the received canonical
    # ID should be used as registration ID ASAP.
    class GCMCanonicalIDResult < GCMResult

      # @return [String]. The suggested canonical ID from GCM
      attr_reader :canonical_id

      def initialize(canonical_id)
        @canonical_id = canonical_id
      end

      def ==(other)
        (other.is_a?(GCMCanonicalIDResult) && @canonical_id == other.canonical_id) ||
        super(other)
      end
    end

    # An error occurred sending the notification to the registration ID.
    class GCMResultError < GCMResult

      # @return [String]. The error sent by GCM
      attr_accessor :error

      def initialize(error)
        @error = error
      end

      def ==(other)
        (other.is_a?(GCMResultError) && @error == other.error) || super(other)
      end
    end
  end
end
