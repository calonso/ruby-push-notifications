
require 'json'

module RubyPushNotifications
  module APNS
    # Represents a APNS Notification.
    # Manages the conversion of the notification to APNS binary format for
    # each of the destinations.
    # By default sets maximum expiration date (4 weeks).
    #
    # @author Carlos Alonso
    class APNSNotification
      extend Forwardable

      def_delegators :@results, :success, :failed, :individual_results

      # @private. 4 weeks in seconds
      WEEKS_4 = 2419200

      # @return [APNSResults] containing the results from sending this notification
      attr_writer :results

      # Initializes the APNS Notification
      #
      # @param [Array]. Array containing all destinations for the notification
      # @param [Hash]. Hash with the data to use as payload.
      def initialize(tokens, data)
        @tokens = tokens
        @data = data
      end

      # Method that yields the notification's binary for each of the receivers.
      #
      # @param starting_id [Integer]. Every notification encodes a unique ID for
      #   further reference. This parameter represents the first id the first
      #   notification of this group should use.
      # @yieldparam [String]. APNS binary's representation of this notification.
      #   Consisting of:
      #     Notification = 2(1), FrameLength(4), items(FrameLength)
      #     Item = ItemID(1), ItemLength(2), data(ItemLength)
      #     Items:
      #       Device Token => Id: 1, length: 32, data: binary device token
      #       Payload => Id: 2, length: ??, data: json formatted payload
      #       Notification ID => Id: 3, length: 4, data: notif id as int
      #       Expiration Date => Id: 4, length: 4, data: Unix timestamp as int
      #       Priority => Id: 5, length: 1, data: 10 as 1 byte int
      # (https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/CommunicatingWIthAPS.html#//apple_ref/doc/uid/TP40008194-CH101-SW4)
      def each_message(starting_id)
        @tokens.each_with_index do |token, i|
          bytes = device_token(token) + payload + notification_id(starting_id + i) + expiration_date + priority
          yield [2, bytes.bytesize, bytes].pack 'cNa*'
        end
      end

      # @return [Integer]. The number of binaries this notification will send.
      #    One for each receiver.
      def count
        @tokens.count
      end

      private

      # @param [String]. The device token to encode.
      # @return [String]. Binary representation of the device token field.
      def device_token(token)
        [1, 32, token].pack 'cnH64'
      end

      # Generates the APNS's binary representation of the notification's payload.
      # Caches the value in an instance variable.
      #
      # @return [String]. Binary representation of the notification's payload.
      def payload
        @encoded_payload ||= -> {
            json = JSON.dump(@data).force_encoding 'ascii-8bit'
            [2, json.bytesize, json].pack 'cna*'
          }.call
      end

      # @param [Integer]. The unique ID for this notification.
      # @return [String]. Binary representation of the notification id field.
      def notification_id(id)
        [3, 4, id].pack 'cnN'
      end

      # @return [String]. Binary representation of the expiration date field.
      def expiration_date
        [4, 4, (Time.now + WEEKS_4).to_i].pack 'cnN'
      end

      # @return [String]. Binary representation of the priority field.
      def priority
        [5, 1, 10].pack 'cnc'
      end
    end
  end
end
