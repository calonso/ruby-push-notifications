require 'uri'
require 'net/https'

module RubyPushNotifications
  module WNS
    # Encapsulates a connection to the WNS service
    # Responsible for final connection with the service.
    #
    class WNSConnection

      # @private Content-Type HTTP Header type string
      CONTENT_TYPE_HEADER  = 'Content-Type'.freeze

      # @private Content-Length HTTP Header type string
      CONTENT_LENGTH_HEADER  = 'Content-Length'.freeze

      # @private WNS type string
      X_WNS_TYPE_HEADER = 'X-WNS-Type'.freeze

      # @private Authorization string
      AUTHORIZATION_HEADER = 'Authorization'.freeze

      # @private Request for status type boolean
      REQUEST_FOR_STATUS_HEADER = 'X-WNS-RequestForStatus'.freeze

      # @private Content-Type type string
      CONTENT_TYPE = {
        badge: 'text/xml',
        toast: 'text/xml',
        tile: 'text/xml',
        raw: 'application/octet-stream'
      }.freeze

      # @private Windows Phone Target Types
      WP_TARGETS = {
        badge: 'wns/badge',
        toast: 'wns/toast',
        tile: 'wns/tile',
        raw: 'wns/raw'
      }.freeze

      # Issues a POST request to the WNS send endpoint to
      # submit the given notifications.
      #
      # @param notifications [WNSNotification]. The notifications object to POST
      # @param access_token [String] required. Access token for send push
      # @param options [Hash] optional. Options for GCMPusher. Currently supports:
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      # @return [Array]. The response of post
      # (http://msdn.microsoft.com/pt-br/library/windows/apps/ff941099)
      def self.post(notifications, access_token, options = {})
        body = notifications.as_wns_xml
        headers = build_headers(access_token, notifications.data[:type], body.length.to_s)
        responses = []
        notifications.each_device do |url|
          http = Net::HTTP.new url.host, url.port
          http.open_timeout = options.fetch(:open_timeout, 30)
          http.read_timeout = options.fetch(:read_timeout, 30)
          if url.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          end
          response = http.post url.request_uri, body, headers
          responses << { device_url: url.to_s, headers: extract_headers(response), code: response.code.to_i }
        end
        WNSResponse.new responses
      end

      # Build Header based on type and delay
      #
      # @param type [String]. Access token
      # @param type [Symbol]. The type of notification
      # @param type [String]. Content length of body
      # @return [Hash]. Correct delay based on notification type
      # https://msdn.microsoft.com/en-us/library/windows/apps/hh465435.aspx#send_notification_request
      def self.build_headers(access_token, type, body_length)
        {
          CONTENT_TYPE_HEADER => CONTENT_TYPE[type],
          X_WNS_TYPE_HEADER => WP_TARGETS[type],
          CONTENT_LENGTH_HEADER => body_length,
          AUTHORIZATION_HEADER => "Bearer #{access_token}",
          REQUEST_FOR_STATUS_HEADER => 'true'
        }
      end

      # Extract headers from response
      # @param response [Net::HTTPResponse]. HTTP response for request
      #
      # @return [Hash]. Hash with headers with case-insensitive keys and string values
      def self.extract_headers(response)
        headers = {}
        response.each_header { |k, v| headers[k] = v.capitalize }
        headers
      end
    end
  end
end
