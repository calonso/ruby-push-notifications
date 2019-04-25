
module RubyPushNotifications
  module FCM
    # Encapsulates a FCM Notification.
    # By default only Required fields are set.
    # (https://developer.android.com/google/fcm/server-ref.html#send-downstream)
    #
    # @author Carlos Alonso
    class FCMNotification
      include RubyPushNotifications::NotificationResultsManager

      # Initializes the notification
      #
      # @param [Array]. Array with the receiver's FCM registration ids.
      # @param [Hash]. Payload to send.
      def initialize(registration_ids, data)
        @registration_ids = registration_ids
        @json_data = {registration_ids: @registration_ids}.merge(data)
      end

      # @return [String]. The FCM's JSON format for the payload to send.
      #    (https://developer.android.com/google/fcm/server-ref.html#send-downstream)
      def as_fcm_json
        JSON.dump(
          @json_data
        )
      end
    end
  end
end
