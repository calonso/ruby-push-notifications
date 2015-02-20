
require 'json'

module RubyPushNotifications
  module APNS
    class APNSNotification

      WEEKS_4 = 2419200 # 4 weeks

      def initialize(token, data)
        @token = token
        @data = data
      end

      def to_apns_binary(id)
        # Notification = 2(1), FrameLength(4), items(FrameLength)
        # Item = ItemID(1), ItemLength(2), data(ItemLength)
        # Items:
        # Device Token => Id: 1, length: 32, data: binary device token
        # Payload => Id: 2, length: ??, data: json formatted payload
        # Notification ID => Id: 3, length: 4, data: notif id as int
        # Expiration Date => Id: 4, length: 4, data: Unix timestamp as int
        # Priority => Id: 5, length: 1, data: 10 as 1 byte int
        bytes = device_token + payload + notification_id(id) + expiration_date + priority
        [2, bytes.bytesize, bytes].pack 'cNa*'
      end

      private

      def device_token
        [1, 32, @token].pack 'cnH64'
      end

      def payload
        json = JSON.dump(@data).force_encoding 'ascii-8bit'
        [2, json.bytesize, json].pack 'cna*'
      end

      def notification_id(id)
        [3, 4, id].pack 'cnN'
      end

      def expiration_date
        [4, 4, (Time.now + WEEKS_4).to_i].pack 'cnN'
      end

      def priority
        [5, 1, 10].pack 'cnc'
      end
    end
  end
end
