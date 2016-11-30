
module RubyPushNotifications
  module MPNS

    # This class is responsible for sending notifications to the MPNS service.
    #
    class MPNSPusher

      # Initializes the MPNSPusher
      #
      # @param certificate [String]. The PEM encoded MPNS certificate.
      # @param options [Hash] optional. Options for GCMPusher. Currently supports:
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      # (http://msdn.microsoft.com/pt-br/library/windows/apps/ff941099)
      def initialize(certificate = nil, options = {})
        @certificate = certificate
        @options = options
      end

      # Actually pushes the given notifications.
      # Assigns every notification an array with the result of each
      # individual notification.
      #
      # @param notifications [Array]. Array of MPNSNotification to send.
      def push(notifications)
        notifications.each do |notif|
          notif.results = MPNSConnection.post notif, @certificate, @options
        end
      end
    end
  end
end
