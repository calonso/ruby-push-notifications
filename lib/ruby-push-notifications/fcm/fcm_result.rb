# frozen_string_literal: true

module RubyPushNotifications
  module FCM
    # Class that encapsulates the result of a single sent notification to a single
    # Registration ID
    # (https://developer.android.com/google/fcm/server-ref.html#table4)
    # @author Carlos Alonso
    class FCMResult; end

    # Indicates that the notification was successfully sent to the corresponding
    # registration ID
    class FCMResultOK < FCMResult

      def ==(other)
        other.is_a?(FCMResultOK) || super(other)
      end
    end

    # Indicates that the notification was successfully sent to the corresponding
    # registration ID but FCM sent a canonical ID for it, so the received canonical
    # ID should be used as registration ID ASAP.
    class FCMCanonicalIDResult < FCMResult

      # @return [String]. The suggested canonical ID from FCM
      attr_reader :canonical_id

      def initialize(canonical_id)
        @canonical_id = canonical_id
      end

      def ==(other)
        (other.is_a?(FCMCanonicalIDResult) && @canonical_id == other.canonical_id) ||
          super(other)
      end
    end

    # An error occurred sending the notification to the registration ID.
    class FCMResultError < FCMResult

      # @return [String]. The error sent by FCM
      attr_accessor :error

      def initialize(error)
        @error = error
      end

      def ==(other)
        (other.is_a?(FCMResultError) && @error == other.error) || super(other)
      end
    end
  end
end
