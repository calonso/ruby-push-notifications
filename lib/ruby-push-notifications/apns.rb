
module RubyPushNotifications::APNS
  NO_ERROR_STATUS_CODE = 0
  PROCESSING_ERROR_STATUS_CODE = 1
  MISSING_DEVICE_TOKEN_STATUS_CODE = 2
  MISSING_TOPIC_STATUS_CODE = 3 # You're writing to the TCPSocket rather than the SSL one
  MISSING_PAYLOAD_STATUS_CODE = 4
  INVALID_TOKEN_SIZE_STATUS_CODE = 5
  INVALID_TOPIC_SIZE_STATUS_CODE = 6
  INVALID_PAYLOAD_SIZE_STATUS_CODE = 7
  INVALID_TOKEN_STATUS_CODE = 8 # The token is for dev and the env is prod or viceversa, or simply wrong
  SHUTDOWN_STATUS_CODE = 10
  UNKNOWN_ERROR_STATUS_CODE = 255
end

require 'ruby-push-notifications/apns/apns_connection'
require 'ruby-push-notifications/apns/apns_notification'
require 'ruby-push-notifications/apns/apns_pusher'

