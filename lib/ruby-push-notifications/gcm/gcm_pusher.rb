
module RubyPushNotifications
  module GCM
    class GCMPusher

      def initialize(key)
        @key = key
      end

      def push(notifications)
        notifications.each do |notif|
          GCMConnection.post notif.as_gcm_json, @key
        end
      end
    end
  end
end
