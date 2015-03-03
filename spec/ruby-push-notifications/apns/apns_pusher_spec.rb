
module RubyPushNotifications
  module APNS
    describe APNSPusher do

      let(:sandbox) { true }
      let(:certificate) { 'abc' }
      let(:socket) { double flush: true, write: true }
      let(:pusher) { APNSPusher.new certificate, sandbox }

      before do
        allow(APNSConnection).to receive(:open).with(certificate, sandbox).and_yield socket
      end

      describe '#push' do

        describe 'a single notification' do
          let(:notification) { build :apns_notification }

          describe 'success' do

            before { allow(IO).to receive(:select).and_return [[]] }

            it 'writes the notification to the socket' do
              expect(socket).to receive(:write).with(notification.to_apns_binary(0))
              pusher.push [notification]
            end

            it 'flushes the socket contents' do
              expect(socket).to receive(:flush)
              pusher.push [notification]
            end

            it 'returns success' do
              expect(pusher.push [notification]).to eq [0]
            end
          end

          describe 'failure' do

            before do
              allow(IO).to receive(:select).and_return [[socket]]
              allow(socket).to receive(:read).with(6).and_return [8, 1, 0].pack 'ccN'
            end

            it 'returns the error' do
              expect(pusher.push [notification]).to eq [1]
            end
          end
        end
      end
    end
  end
end
