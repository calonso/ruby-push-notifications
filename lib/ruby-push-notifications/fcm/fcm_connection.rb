require 'uri'
require 'net/https'

module RubyPushNotifications
  module FCM
    # Encapsulates a connection to the FCM service
    # Responsible for final connection with the service.
    #
    # @author Carlos Alonso
    class FCMConnection

      # @private The URL of the Android FCM endpoint
      # Credits: https://github.com/calos0921 - for this url change to FCM std
      FCM_URL = 'https://fcm.googleapis.com/fcm/send'

      # @private Content-Type HTTP Header string
      CONTENT_TYPE_HEADER  = 'Content-Type'

      # @private Application/JSON content type
      JSON_CONTENT_TYPE    = 'application/json'

      # @private Authorization HTTP Header String
      AUTHORIZATION_HEADER = 'Authorization'

      # Issues a POST request to the FCM send endpoint to
      # submit the given notifications.
      #
      # @param notification [String]. The text to POST
      # @param key [String]. The FCM sender id to use
      #    (https://developer.android.com/google/fcm/fcm.html#senderid)
      # @param options [Hash] optional. Options for #post. Currently supports:
      #   * url [String]: URL of the FCM endpoint. Defaults to the official FCM URL.
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      # @return [FCMResponse]. The FCMResponse that encapsulates the received response
      def self.post(notification, key, options = {})
        headers = {
            CONTENT_TYPE_HEADER => JSON_CONTENT_TYPE,
            AUTHORIZATION_HEADER => "key=#{key}"
        }

        url = URI.parse options.fetch(:url, FCM_URL)
        http = Net::HTTP.new url.host, url.port
        http.use_ssl = url.scheme == 'https'
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.open_timeout = options.fetch(:open_timeout, 30)
        http.read_timeout = options.fetch(:read_timeout, 30)

        response = http.post url.path, notification, headers

        FCMResponse.new response.code.to_i, response.body
      end
    end
  end
end
