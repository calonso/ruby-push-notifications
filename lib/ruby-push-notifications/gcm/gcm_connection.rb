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
      # @return [GCMResponse]. The GCMResponse that encapsulates the received response
      def self.post(notification, key)
        headers = {
            CONTENT_TYPE_HEADER => JSON_CONTENT_TYPE,
            AUTHORIZATION_HEADER => "key=#{key}"
        }

        url = URI.parse GCM_URL
        http = Net::HTTP.new url.host, url.port
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.post url.path, notification, headers

        GCMResponse.new response.code.to_i, response.body
      end
    end
  end
end
