
module RubyPushNotifications
  module GCM
    class GCMResponse

      def initialize(code, body)
        case code
        when 200
        when 400
          raise MalformedGCMJSONError, body
        when 401
          raise GCMAuthError, body
        when 500..599
          raise GCMInternalError, body
        else
          raise UnexpectedGCMResponseError, code
        end
      end
    end
  end
end
