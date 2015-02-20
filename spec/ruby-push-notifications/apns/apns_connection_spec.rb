
module RubyPushNotifications
  module APNS
    describe APNSConnection do

      describe '::open' do
        let(:tcp_socket) { double(TCPSocket, close: true) }
        let(:ssl_socket) { double(OpenSSL::SSL::SSLSocket, :sync= => true, connect: true, close: true) }
        let(:cert) { File.read 'spec/support/dummy.pem' }

        before do
          allow(TCPSocket).to receive(:new).with('gateway.sandbox.push.apple.com', 2195).and_return tcp_socket
          allow(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket, an_instance_of(OpenSSL::SSL::SSLContext)).and_return ssl_socket
        end

        it 'creates the connection' do
          expect(TCPSocket).to receive(:new).with('gateway.sandbox.push.apple.com', 2195).and_return tcp_socket
          expect(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket, an_instance_of(OpenSSL::SSL::SSLContext)).and_return ssl_socket
          APNSConnection.open(cert, true) {}
        end

        it 'yields the ssl socket' do
          expect do |b|
            APNSConnection.open(cert, true, &b)
          end.to yield_with_args ssl_socket
        end
      end
    end
  end
end
