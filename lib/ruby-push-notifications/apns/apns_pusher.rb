
module RubyPushNotifications
  module APNS
    class APNSPusher

      def initialize(certificate, sandbox)
        @certificate = certificate
        @sandbox = sandbox
      end

      def push(notifications)
        conn = APNSConnection.open @certificate, @sandbox

        notifications.each_with_index do |notif, i|
          results = []
          notif.each_message(i) do |msg, j|
            conn.write msg

            if i == notifications.count-1 && j == notif.count-1
              conn.flush
              rs, = IO.select([conn], nil, nil, 2)
            else
              rs, = IO.select([conn], [conn])
            end
            if rs && rs.any?
              err = rs[0].read(6).unpack 'ccN'
              results.slice! err[2]..-1
              results << err[1]
              conn = APNSConnection.open @certificate, @sandbox
            else
              results << NO_ERROR_STATUS_CODE
            end
          end
          notif.results = results
        end

        conn.close
      end
    end
  end
end
