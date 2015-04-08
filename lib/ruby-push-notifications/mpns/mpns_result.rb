
module RubyPushNotifications
  module MPNS
    # Class that encapsulates the result of a single sent notification to a single
    # Device URL
    # (https://msdn.microsoft.com/en-us/library/windows/apps/ff941100%28v=vs.105%29.aspx)
    class MPNSResult
      # @return [String]. Receiver MPNS device URL.
      attr_accessor :device_url
    end

    # Indicates that the notification was successfully sent to the corresponding
    # device URL
    class MPNSResultOK < MPNSResult
      # @return [String]. The status of the notification received
      # by the Microsoft Push Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. The subscription status.
      attr_accessor :subscription_status

      def initialize(device_url, headers = nil)
        @device_url = device_url
        @notification_status = headers['x-notificationstatus'][0]
        @device_connection_status = headers['x-deviceconnectionstatus'][0]
        @subscription_status = headers['x-subscriptionstatus'][0]
      end

      def ==(other)
        (other.is_a?(MPNSResultOK) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          subscription_status == other.subscription_status) || super(other)
      end
    end

    # This error occurs when the cloud service sends a notification
    # request with a bad XML document or malformed notification URI.
    class MalformedMPNSResultError < MPNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(MalformedMPNSResultError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # Sending this notification is unauthorized.
    class MPNSAuthError < MPNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(MPNSAuthError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # The subscription is invalid and is not present on the Push Notification Service.
    class MPNSInvalidError < MPNSResult
      # @return [String]. The status of the notification received
      # by the Microsoft Push Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. The subscription status.
      attr_accessor :subscription_status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers['x-notificationstatus'][0]
        @device_connection_status = headers['x-deviceconnectionstatus'][0]
        @subscription_status = headers['x-subscriptionstatus'][0]
      end

      def ==(other)
        (other.is_a?(MPNSInvalidError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          subscription_status == other.subscription_status) || super(other)
      end
    end

    # This error occurs when an unauthenticated cloud service has reached
    # the per-day throttling limit for a subscription,
    # or when a cloud service (authenticated or unauthenticated)
    # has sent too many notifications per second.
    class MPNSLimitError < MPNSResult
      # @return [String]. The status of the notification received
      # by the Microsoft Push Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. The subscription status.
      attr_accessor :subscription_status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers['x-notificationstatus'][0]
        @device_connection_status = headers['x-deviceconnectionstatus'][0]
        @subscription_status = headers['x-subscriptionstatus'][0]
      end

      def ==(other)
        (other.is_a?(MPNSLimitError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          subscription_status == other.subscription_status) || super(other)
      end
    end

    # The device is in a disconnected state.
    class MPNSPreConditionError < MPNSResult
      # @return [String]. The status of the notification received
      # by the Microsoft Push Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers['x-notificationstatus'][0]
        @device_connection_status = headers['x-deviceconnectionstatus'][0]
      end

      def ==(other)
        (other.is_a?(MPNSPreConditionError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status) || super(other)
      end
    end

    # The Push Notification Service is unable to process the request.
    class MPNSInternalError < MPNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(MPNSInternalError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # Unknow Error
    class MPNSResultError < MPNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(MPNSResultError) &&
          device_url == other.device_url) || super(other)
      end
    end
  end
end
