
require 'socket'
require 'openssl'
require 'forwardable'

module RubyPushNotifications
  module APNS
    class APNSConnection
      extend Forwardable

      APNS_SANDBOX_URL = 'gateway.sandbox.push.apple.com'
      APNS_PRODUCTION_URL = 'gateway.push.apple.com'
      APNS_PORT = 2195

      def_delegators :@sslsock, :write, :flush, :to_io, :read

      def self.open(cert, sandbox)
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.key = OpenSSL::PKey::RSA.new cert
        ctx.cert = OpenSSL::X509::Certificate.new cert

        h = host sandbox
        socket = TCPSocket.new h, APNS_PORT
        ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
        ssl.connect

        new socket, ssl
      end

      def self.host(sandbox)
        sandbox ? APNS_SANDBOX_URL : APNS_PRODUCTION_URL
      end

      def initialize(tcpsock, sslsock)
        @tcpsock = tcpsock
        @sslsock = sslsock
      end

      def close
        @sslsock.close
        @tcpsock.close
      end
    end
  end
end
