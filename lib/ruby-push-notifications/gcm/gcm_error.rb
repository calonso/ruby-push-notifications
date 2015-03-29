
module RubyPushNotifications
  module GCM
    class GCMError < StandardError ; end

    class MalformedGCMJSONError < GCMError ; end

    class GCMAuthError < GCMError ; end

    class GCMInternalError < GCMError ; end

    class UnexpectedGCMResponseError < GCMError ; end
  end
end
