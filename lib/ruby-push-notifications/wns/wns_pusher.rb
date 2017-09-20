module RubyPushNotifications
  module WNS

    # This class is responsible for sending notifications to the WNS service.
    #
    class WNSPusher

      # Initializes the WNSPusher
      #
      # @param access_token [String]. WNS access token.
      # @param options [Hash] optional. Options for GCMPusher. Currently supports:
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      # (http://msdn.microsoft.com/pt-br/library/windows/apps/ff941099)
      def initialize(access_token, options = {})
        @access_token = access_token
        @options = options
      end

      # Actually pushes the given notifications.
      # Assigns every notification an array with the result of each
      # individual notification.
      #
      # @param notifications [Array]. Array of WNSNotification to send.
      def push(notifications)
        notifications.each do |notif|
          notif.results = WNSConnection.post notif, @access_token, @options
        end
      end
    end
  end
end
