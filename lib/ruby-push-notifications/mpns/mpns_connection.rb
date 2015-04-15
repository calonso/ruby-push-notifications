require 'uri'
require 'net/https'

module RubyPushNotifications
  module MPNS
    # Encapsulates a connection to the MPNS service
    # Responsible for final connection with the service.
    #
    class MPNSConnection

      # @private Content-Type HTTP Header string
      CONTENT_TYPE_HEADER  = 'Content-Type'

      # @private text/xml content type
      X_NOTIFICATION_CLASS = 'X-NotificationClass'

      # @private Windows Phone Target
      X_WINDOWSPHONE_TARGET = 'X-WindowsPhone-Target'

      # @private text/xml content type
      XML_CONTENT_TYPE     = 'text/xml'

      # @private Enumators for notification types
      BASEBATCH = { tile: 1, toast: 2, raw: 3 }

      # @private Enumators for delay
      BATCHADDS = { delay450: 10, delay900: 20 }

      # @private Windows Phone Target Types
      WP_TARGETS = { toast: 'toast', tile: 'token' }

      # Issues a POST request to the MPNS send endpoint to
      # submit the given notifications.
      #
      # @param n [MPNSNotification]. The notification object to POST
      # @param optional cert [String]. Contents of the PEM encoded certificate
      # @return [Array]. The response of post
      # (http://msdn.microsoft.com/pt-br/library/windows/apps/ff941099)
      def self.post(n, cert = nil)
        headers = build_headers(n.data[:type], n.data[:delay])
        body = n.as_mpns_xml
        responses = []
        n.each_device do |url|
          http = Net::HTTP.new url.host, url.port
          if cert && url.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.ca_file = cert
          end
          response = http.post url.path, body, headers
          responses << { device_url: url.to_s, headers: extract_headers(response), code: response.code.to_i }
        end
        MPNSResponse.new responses
      end

      # Build Header based on type and delay
      #
      # @param type [Symbol]. The type of notification
      # @param delay [Symbol]. The delay to be used
      # @return [Hash]. Correct delay based on notification type
      def self.build_headers(type, delay)
        headers = {
          CONTENT_TYPE_HEADER => XML_CONTENT_TYPE,
          X_NOTIFICATION_CLASS => "#{(BASEBATCH[type] + (BATCHADDS[delay] || 0))}"
        }
        headers[X_WINDOWSPHONE_TARGET] = WP_TARGETS[type] unless type == :raw
        headers
      end

      # Extract headers from response
      # @param response [Net::HTTPResponse]. HTTP response for request
      #
      # @return [Hash]. Hash with headers with case-insensitive keys and string values
      def self.extract_headers(response)
        headers = {}
        response.each_header { |k, v| headers[k] = v }
        headers
      end

    end
  end
end
