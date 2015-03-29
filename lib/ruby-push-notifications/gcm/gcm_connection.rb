require 'uri'
require 'net/https'

module RubyPushNotifications
  module GCM
    class GCMConnection

      GCM_URL = 'https://android.googleapis.com/gcm/send'

      CONTENT_TYPE_HEADER  = 'Content-Type'
      JSON_CONTENT_TYPE    = 'application/json'
      AUTHORIZATION_HEADER = 'Authorization'

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
