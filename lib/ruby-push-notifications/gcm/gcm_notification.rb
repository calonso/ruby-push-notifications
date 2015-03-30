
module RubyPushNotifications
  module GCM
    # Encapsulates a GCM Notification.
    # By default only Required fields are set.
    # (https://developer.android.com/google/gcm/server-ref.html#send-downstream)
    #
    # @author Carlos Alonso
    class GCMNotification

      # @return [Array]. Array with the results from sending this notification
      attr_accessor :results

      # Initializes the notification
      #
      # @param [Array]. Array with the receiver's GCM registration ids.
      # @param [Hash]. Payload to send.
      def initialize(registration_ids, data)
        @registration_ids = registration_ids
        @data = data
      end

      # @return [String]. The GCM's JSON format for the payload to send.
      #    (https://developer.android.com/google/gcm/server-ref.html#send-downstream)
      def as_gcm_json
        JSON.dump(
          registration_ids: @registration_ids,
          data: @data
        )
      end
    end
  end
end
