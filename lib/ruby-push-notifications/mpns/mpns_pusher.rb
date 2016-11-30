
module RubyPushNotifications
  module MPNS

    # This class is responsible for sending notifications to the MPNS service.
    #
    class MPNSPusher

      # Initializes the MPNSPusher
      #
      # @param certificate [String]. The PEM encoded MPNS certificate.
      # @param optional options [Hash]. Options for the HTTP connection.
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
