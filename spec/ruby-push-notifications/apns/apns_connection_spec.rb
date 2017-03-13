
module RubyPushNotifications
  module APNS
    describe APNSConnection do

      let(:cert) { File.read 'spec/support/dummy.pem' }
      let(:tcp_socket) { instance_double(Socket).as_null_object }
      let(:ssl_socket) { instance_double(OpenSSL::SSL::SSLSocket).as_null_object }

      describe '::open' do
        before do
          allow(Socket).to receive(:tcp).with('gateway.sandbox.push.apple.com', 2195, nil, nil, { connect_timeout: 30 }).and_return tcp_socket
          allow(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket, an_instance_of(OpenSSL::SSL::SSLContext)).and_return ssl_socket
        end

        it 'creates the connection' do
          expect(Socket).to receive(:tcp).with('gateway.sandbox.push.apple.com', 2195, nil, nil, { connect_timeout: 30 }).and_return tcp_socket
          expect(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket, an_instance_of(OpenSSL::SSL::SSLContext)).and_return ssl_socket
          APNSConnection.open cert, true
        end

        it 'returns an instance of APNSConnection' do
          expect(APNSConnection.open(cert, true)).to be_a APNSConnection
        end

        it 'sets the password for pem file' do
          expect(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket, an_instance_of(OpenSSL::SSL::SSLContext)).and_return ssl_socket
          expect(OpenSSL::PKey::RSA).to receive(:new).with(cert, 'password')
          expect(APNSConnection.open(cert, true, 'password')).to be_a APNSConnection
        end

        context 'when :apns_url option is present' do
          it 'opens a connection with a custom APNS' do
            expect(Socket).to receive(:tcp).with('gateway.push.example.com', 2195, nil, nil, { connect_timeout: 30 }).and_return tcp_socket
            APNSConnection.open cert, true, 'password', { apns_url: "gateway.push.example.com" }
          end
        end
      end

      describe '#close' do
        let(:connection) { APNSConnection.new tcp_socket, ssl_socket }

        it 'closes the ssl socket' do
          expect(ssl_socket).to receive(:close)
          connection.close
        end

        it 'closes the tcp socket' do
          expect(tcp_socket).to receive(:close)
          connection.close
        end
      end

      describe '#write' do
        let(:connection) { APNSConnection.new tcp_socket, ssl_socket }
        let(:contents_string) { 'the contents string' }

        it 'writes the ssl socket' do
          expect(ssl_socket).to receive(:write).with contents_string
          connection.write contents_string
        end
      end

      describe '#read' do
        let(:connection) { APNSConnection.new tcp_socket, ssl_socket }

        it 'writes the ssl socket' do
          expect(ssl_socket).to receive(:read).with 6
          connection.read 6
        end
      end

      describe '#flush' do
        let(:connection) { APNSConnection.new tcp_socket, ssl_socket }

        it 'flushes the ssl socket' do
          expect(ssl_socket).to receive :flush
          connection.flush
        end
      end

      describe 'IO behavior' do
        let(:connection) { APNSConnection.new tcp_socket, ssl_socket }

        it 'can be selected' do
          allow(ssl_socket).to receive(:to_io).and_return IO.new(IO.sysopen('/dev/null'))
          IO.select [connection]
        end
      end
    end
  end
end
