require 'socket'
require 'openssl'

module RubyPushNotifications
  module APNS
    # This class encapsulates a connection with APNS.
    #
    # @author Carlos Alonso
    class APNSConnection
      extend Forwardable

      # @private URL of the APNS Sandbox environment
      APNS_SANDBOX_URL = 'gateway.sandbox.push.apple.com'

      # @private URL of APNS production environment
      APNS_PRODUCTION_URL = 'gateway.push.apple.com'

      # @private Port to connect to
      APNS_PORT = 2195

      def_delegators :@sslsock, :write, :flush, :to_io, :read

      # Opens a connection with APNS
      #
      # @param cert [String]. Contents of the PEM encoded certificate
      # @param sandbox [Boolean]. Whether to use the sandbox environment or not.
      # @param pass [String] optional. Passphrase for the certificate.
      # @param options [Hash] optional. Options for #open. Currently supports:
      #   * apns_host [String]: Hostname of the APNS environment. Defaults to the official APNS hostname.
      #   * connect_timeout [Integer]: how long the socket will wait for when opening the APNS socket. Defaults to 30.
      # @return [APNSConnection]. The recently stablished connection.
      def self.open(cert, sandbox, pass = nil, options = {})
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.key = OpenSSL::PKey::RSA.new cert, pass
        ctx.cert = OpenSSL::X509::Certificate.new cert

        h = options.fetch(:apns_host, host(sandbox))
        socket = Socket.tcp h, APNS_PORT, nil, nil, connect_timeout: options.fetch(:connect_timeout, 30)
        ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
        ssl.connect

        new socket, ssl
      end

      # Returns the URL to connect to.
      #
      # @param sandbox [Boolean]. Whether it is the sandbox or the production
      #  environment we're looking for.
      # @return [String]. The URL for the APNS service.
      def self.host(sandbox)
        sandbox ? APNS_SANDBOX_URL : APNS_PRODUCTION_URL
      end

      # Initializes the APNSConnection
      #
      # @param tcpsock [TCPSocket]. The used TCP Socket.
      # @param sslsock [SSLSocket]. The connected SSL Socket.
      def initialize(tcpsock, sslsock)
        @tcpsock = tcpsock
        @sslsock = sslsock
      end

      # Closes the APNSConnection
      def close
        @sslsock.close
        @tcpsock.close
      end
    end
  end
end
