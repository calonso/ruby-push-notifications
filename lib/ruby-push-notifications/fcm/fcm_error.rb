
module RubyPushNotifications
  module FCM
    # Base class for all FCM related errors
    #
    # @author Carlos Alonso
    class FCMError < StandardError ; end

    class MalformedFCMJSONError < FCMError ; end

    class FCMAuthError < FCMError ; end

    class FCMInternalError < FCMError ; end

    class UnexpectedFCMResponseError < FCMError ; end
  end
end
