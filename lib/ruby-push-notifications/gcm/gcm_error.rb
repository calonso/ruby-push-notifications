
module RubyPushNotifications
  module GCM
    # Base class for all GCM related errors
    #
    # @author Carlos Alonso
    class GCMError < StandardError ; end

    class MalformedGCMJSONError < GCMError ; end

    class GCMAuthError < GCMError ; end

    class GCMInternalError < GCMError ; end

    class UnexpectedGCMResponseError < GCMError ; end
  end
end
