
module RubyPushNotifications
  module GCM

    # This class is responsible for sending notifications to the GCM service.
    #
    # @author Carlos Alonso
    class GCMPusher

      # Initializes the GCMPusher
      #
      # @param key [String]. GCM sender id to use
      #   ((https://developer.android.com/google/gcm/gcm.html#senderid))
      # @param optional options [Hash]. Options for the HTTP connection.
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      # Actually pushes the given notifications.
      # Assigns every notification an array with the result of each
      # individual notification.
      #
      # @param notifications [Array]. Array of GCMNotification to send.
      def push(notifications)
        notifications.each do |notif|
          notif.results = GCMConnection.post notif.as_gcm_json, @key, @options
        end
      end
    end
  end
end
