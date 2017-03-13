require 'uri'
require 'net/https'

module RubyPushNotifications
  module GCM
    # Encapsulates a connection to the GCM service
    # Responsible for final connection with the service.
    #
    # @author Carlos Alonso
    class GCMConnection

      # @private The URL of the Android GCM endpoint
      GCM_URL = 'https://android.googleapis.com/gcm/send'

      # @private Content-Type HTTP Header string
      CONTENT_TYPE_HEADER  = 'Content-Type'

      # @private Application/JSON content type
      JSON_CONTENT_TYPE    = 'application/json'

      # @private Authorization HTTP Header String
      AUTHORIZATION_HEADER = 'Authorization'

      # Issues a POST request to the GCM send endpoint to
      # submit the given notifications.
      #
      # @param notification [String]. The text to POST
      # @param key [String]. The GCM sender id to use
      #    (https://developer.android.com/google/gcm/gcm.html#senderid)
      # @param options [Hash] optional. Options for #post. Currently supports:
      #   * gcm_url [String]: The URL of the Android GCM endpoint
      #   * open_timeout [Integer]: Number of seconds to wait for the connection to open. Defaults to 30.
      #   * read_timeout [Integer]: Number of seconds to wait for one block to be read. Defaults to 30.
      # @return [GCMResponse]. The GCMResponse that encapsulates the received response
      def self.post(notification, key, options = {})
        headers = {
            CONTENT_TYPE_HEADER => JSON_CONTENT_TYPE,
            AUTHORIZATION_HEADER => "key=#{key}"
        }

        url = URI.parse options.fetch(:gcm_url, GCM_URL)
        http = Net::HTTP.new url.host, url.port
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.open_timeout = options.fetch(:open_timeout, 30)
        http.read_timeout = options.fetch(:read_timeout, 30)

        response = http.post url.path, notification, headers

        GCMResponse.new response.code.to_i, response.body
      end
    end
  end
end
