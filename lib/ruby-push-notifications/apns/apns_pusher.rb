
module RubyPushNotifications
  module APNS
    class APNSPusher

      def initialize(certificate, sandbox)
        @certificate = certificate
        @sandbox = sandbox
      end

      def push(notifications)
        results = []
        while results.count < notifications.count
          APNSConnection.open(@certificate, @sandbox) do |socket|
            notifications[results.count..-1].each_with_index do |notif, i|
              socket.write notif.to_apns_binary i

              if i == notifications.count-1
                socket.flush
                rs, = IO.select([socket], nil, nil, 2)
              else
                rs, = IO.select([socket], [socket])
              end
              if rs && rs.any?
                err = rs[0].read(6).unpack 'ccN'
                results.slice! err[2]..-1
                results << err[1]
                break
              else
                results << NO_ERROR_STATUS_CODE
              end
            end
          end
        end
        return results
      end
    end
  end
end
