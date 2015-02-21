
module RubyPushNotifications
  module APNS
    class APNSPusher

      def initialize(certificate, sandbox)
        @certificate = certificate
        @sandbox = sandbox
      end

      def push(notifications)
        APNSConnection.open(@certificate, @sandbox) do |socket|
          notifications.each_with_index do |notif, i|
            socket.write notif.to_apns_binary i
            socket.flush
            begin
              err = socket.read_nonblock 6
              puts "ERROR! err.unpack 'ccN'"
            rescue IO::WaitReadable
            end
          end
        end
      end
    end
  end
end
