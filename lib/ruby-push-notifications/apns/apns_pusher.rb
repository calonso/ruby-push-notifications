
module RubyPushNotifications
  module APNS
    class APNSPusher

      def initialize(certificate, sandbox)
        @certificate = certificate
        @sandbox = sandbox
      end

      def push(notifications)
        conn = APNSConnection.open @certificate, @sandbox

        binaries = notifications.each_with_object([]) do |notif, binaries|
          notif.each_message(binaries.count) do |msg|
            binaries << msg
          end
        end

        results = []
        i = 0
        while i < binaries.count
          conn.write binaries[i]

          if i == binaries.count-1
            conn.flush
            rs, = IO.select([conn], nil, nil, 2)
          else
            rs, = IO.select([conn], [conn])
          end
          if rs && rs.any?
            err = rs[0].read(6).unpack 'ccN'
            results.slice! err[2]..-1
            results << err[1]
            i = err[2]
            conn = APNSConnection.open @certificate, @sandbox
          else
            results << NO_ERROR_STATUS_CODE
          end
          i += 1
        end

        conn.close

        notifications.each do |notif|
          notif.results = results.slice! 0, notif.count
        end
      end
    end
  end
end
