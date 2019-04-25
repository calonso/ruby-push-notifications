
module RubyPushNotifications
  module FCM

    # This class is responsible for sending notifications to the FCM service.
    #
    # @author Carlos Alonso
    class FCMPusher

      # Initializes the FCMPusher
      #
      # @param key [String]. FCM sender id to use
      #   ((https://developer.android.com/google/fcm/fcm.html#senderid))
      # @param options [Hash] optional. Options for FCMPusher. Currently supports:
      #   * url [String]: URL of the FCM endpoint. Defaults to the official FCM URL.
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      # Actually pushes the given notifications.
      # Assigns every notification an array with the result of each
      # individual notification.
      #
      # @param notifications [Array]. Array of FCMNotification to send.
      def push(notifications)
        notifications.each do |notif|
          notif.results = FCMConnection.post notif.as_fcm_json, @key, @options
        end
      end
    end
  end
end
