#
# @author Carlos Alonso
#
module RubyPushNotifications::APNS

  # No Status Error Code. Represents a successfully sent notification
  NO_ERROR_STATUS_CODE = 0

  # An error occurred while processing the notification
  PROCESSING_ERROR_STATUS_CODE = 1

  # The notification contains no device token
  MISSING_DEVICE_TOKEN_STATUS_CODE = 2

  # The notification is being sent through the plain TCPSocket,
  # rather than the SSL one
  MISSING_TOPIC_STATUS_CODE = 3

  # The notification contains no payload
  MISSING_PAYLOAD_STATUS_CODE = 4

  # The given token sice is invalid (!= 32)
  INVALID_TOKEN_SIZE_STATUS_CODE = 5

  # The given topic size is invalid
  INVALID_TOPIC_SIZE_STATUS_CODE = 6

  # Payload size is invalid (256 bytes if iOS < 8, 2Kb otherwise)
  INVALID_PAYLOAD_SIZE_STATUS_CODE = 7

  # The token is for dev and the env is prod or viceversa, or simply wrong
  INVALID_TOKEN_STATUS_CODE = 8

  # Connection closed at Apple's end
  SHUTDOWN_STATUS_CODE = 10

  # Unknown error
  UNKNOWN_ERROR_STATUS_CODE = 255
end

require 'ruby-push-notifications/apns/apns_connection'
require 'ruby-push-notifications/apns/apns_notification'
require 'ruby-push-notifications/apns/apns_pusher'

