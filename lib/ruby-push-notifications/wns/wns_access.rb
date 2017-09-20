require 'uri'
require 'net/https'
require 'json'
require 'ostruct'

module RubyPushNotifications
  module WNS
    # This class is responsible for get access auth token for sending pushes
    #
    class WNSAccess

      # This class is responsible for structurize response from login WNS service
      #
      class Response
        # @return [OpenStruct]. Return structurized response
        attr_reader :response

        def initialize(response)
          @response = structurize(response)
        end

        private

        def structurize(response)
          body = response.body.to_s.empty? ? {} : JSON.parse(response.body)
          OpenStruct.new(
            status_code: response.code.to_i,
            status: response.message,
            error: body['error'],
            error_description: body['error_description'],
            access_token: body['access_token'],
            token_ttl: body['expires_in']
          )
        end
      end

      # @private Grant type for getting access token
      GRANT_TYPE = 'client_credentials'.freeze

      # @private Scope for getting access token
      SCOPE = 'notify.windows.com'.freeze

      # @private Url for getting access token
      ACCESS_TOKEN_URL = 'https://login.live.com/accesstoken.srf'.freeze

      # @return [String]. Sid
      attr_reader :sid

      # @return [String]. Secret token
      attr_reader :secret

      # @param type [String]. Sid
      # @param type [String]. Secret
      #
      # You can get it on https://account.live.com/developers/applications/index
      def initialize(sid, secret)
        @sid = sid
        @secret = secret
      end

      # Get access auth token for sending pushes
      #
      # https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/tiles-and-notifications-windows-push-notification-services--wns--overview
      def get_token
        body = {
          grant_type: GRANT_TYPE,
          client_id: sid,
          client_secret: secret,
          scope: SCOPE
        }

        url = URI.parse ACCESS_TOKEN_URL
        http = Net::HTTP.new url.host, url.port
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        response = http.post url.request_uri, URI.encode_www_form(body)

        Response.new response
      end
    end
  end
end
