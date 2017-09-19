module RubyPushNotifications
  module WNS
    # Class that encapsulates the result of a single sent notification to a single
    # Device URL
    # https://msdn.microsoft.com/en-us/library/windows/apps/hh465435.aspx#WNSResponseCodes
    class WNSResult
      # @return [String]. Receiver WNS device URL.
      attr_accessor :device_url

      # @private X-WNS-NotificationStatus HTTP Header string
      X_NOTIFICATION_STATUS  = 'x-wns-notificationstatus'

      # @private X-WNS-DeviceConnectionStatus HTTP Header string
      X_DEVICE_CONNECTION_STATUS  = 'x-wns-deviceconnectionstatus'

      # @private X-SubscriptionStatus HTTP Header string
      X_STATUS  = 'x-wns-status'
    end

    # Indicates that the notification was successfully sent to the corresponding
    # device URL
    class WNSResultOK < WNSResult
      # @return [String]. The status of the notification received
      # by the Windows Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. Notification status.
      attr_accessor :status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers[X_NOTIFICATION_STATUS]
        @device_connection_status = headers[X_DEVICE_CONNECTION_STATUS]
        @status = headers[X_STATUS]
      end

      def ==(other)
        (other.is_a?(WNSResultOK) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          status == other.status) || super(other)
      end
    end

    # This error occurs when the cloud service sends a notification
    # request with a bad XML document or malformed notification URI.
    class MalformedWNSResultError < WNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(MalformedWNSResultError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # Sending this notification is unauthorized.
    class WNSAuthError < WNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(WNSAuthError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # Notification is invalid and is not present on the Push Notification Service.
    class WNSInvalidError < WNSResult
      # @return [String]. The status of the notification received
      # by the Windows Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. Notification status.
      attr_accessor :status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers[X_NOTIFICATION_STATUS]
        @device_connection_status = headers[X_DEVICE_CONNECTION_STATUS]
        @status = headers[X_STATUS]
      end

      def ==(other)
        (other.is_a?(WNSInvalidError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          status == other.status) || super(other)
      end
    end

    # This error occurs when an unauthenticated cloud service has reached
    # the per-day throttling limit for a subscription,
    # or when a cloud service (authenticated or unauthenticated)
    # has sent too many notifications per second.
    class WNSLimitError < WNSResult
      # @return [String]. The status of the notification received
      # by the Windows Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. Notification status.
      attr_accessor :status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers[X_NOTIFICATION_STATUS]
        @device_connection_status = headers[X_DEVICE_CONNECTION_STATUS]
        @status = headers[X_STATUS]
      end

      def ==(other)
        (other.is_a?(WNSLimitError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          status == other.status) || super(other)
      end
    end

    # The device is in a disconnected state.
    class WNSPreConditionError < WNSResult
      # @return [String]. The status of the notification received
      # by the Windows Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers[X_NOTIFICATION_STATUS]
        @device_connection_status = headers[X_DEVICE_CONNECTION_STATUS]
      end

      def ==(other)
        (other.is_a?(WNSPreConditionError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status) || super(other)
      end
    end

    # The device is in a disconnected state.
    class WNSExpiredError < WNSResult
      # @return [String]. The status of the notification received
      # by the Windows Notification Service.
      attr_accessor :notification_status

      # @return [String]. The connection status of the device.
      attr_accessor :device_connection_status

      # @return [String]. Notification status.
      attr_accessor :status

      def initialize(device_url, headers)
        @device_url = device_url
        @notification_status = headers[X_NOTIFICATION_STATUS]
        @device_connection_status = headers[X_DEVICE_CONNECTION_STATUS]
        @status = 'Expired'.freeze
      end

      def ==(other)
        (other.is_a?(WNSExpiredError) &&
          device_url == other.device_url &&
          notification_status == other.notification_status &&
          device_connection_status == other.device_connection_status &&
          status == other.status) || super(other)
      end
    end

    # The Push Notification Service is unable to process the request.
    class WNSInternalError < WNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(WNSInternalError) &&
          device_url == other.device_url) || super(other)
      end
    end

    # Unknow Error
    class WNSResultError < WNSResult
      def initialize(device_url)
        @device_url = device_url
      end

      def ==(other)
        (other.is_a?(WNSResultError) &&
          device_url == other.device_url) || super(other)
      end
    end
  end
end
