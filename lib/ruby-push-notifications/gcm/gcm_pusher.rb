
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
      # @param options [Hash] optional. Options for GCMPusher. Currently supports:
      #   * url [String]: URL of the GCM endpoint. Defaults to the official GCM URL.
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      #   * slice_quantity [Integer]: Number of notifications to send to avoid hard limits. Defaults to 500.
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
        notifications.each_slice(@options[:slice_quantity] || 500).with_index do |notifications_slice|
          notifications_slice.each do |notif|
            notif.results = GCMConnection.post notif.as_gcm_json, @key, @options
          end
        end
      end
    end
  end
end
