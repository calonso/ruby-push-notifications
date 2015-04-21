
module RubyPushNotifications
  module APNS
    describe APNSPusher do

      let(:sandbox) { true }
      let(:certificate) { 'abc' }
      let(:pusher) { APNSPusher.new certificate, sandbox }
      let(:connection) { instance_double(APNSConnection).as_null_object }
      let(:data) { { a: 1 } }

      before do
        allow(APNSConnection).to receive(:open).with(certificate, sandbox).and_return connection
      end

      describe '#push' do

        context 'a single notification' do

          context 'containing a single destination' do

            let(:token) { generate :apns_token }
            let(:notification) { build :apns_notification, data: data, tokens: [token] }

            describe 'success' do

              before { allow(IO).to receive(:select).and_return [] }

              it 'writes the notification to the socket' do
                expect(connection).to receive(:write).with apns_binary(data, token, 0)
                pusher.push [notification]
              end

              it 'flushes the socket contents' do
                expect(connection).to receive(:flush)
                pusher.push [notification]
              end

              describe 'results' do
                before { pusher.push [notification] }

                include_examples 'right results', 1, 0, [NO_ERROR_STATUS_CODE]
              end
            end

            describe 'failure' do

              before do
                allow(IO).to receive(:select).and_return [[connection]]
                allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 0].pack 'ccN'
              end

              it 'does not retry' do
                expect(connection).to receive(:write).with(apns_binary(data, token, 0)).once
                pusher.push [notification]
              end

              describe 'results' do
                before { pusher.push [notification] }

                include_examples 'right results', 0, 1, [PROCESSING_ERROR_STATUS_CODE]
              end
            end
          end

          context 'containing several destinations' do
            let(:tokens) { [generate(:apns_token), generate(:apns_token)] }
            let(:notification) { build :apns_notification, data: data, tokens: tokens }

            describe 'success' do

              before { allow(IO).to receive(:select).and_return [] }

              it 'writes the messages to the socket' do
                expect(connection).to receive(:write).with apns_binary(data, tokens[0], 0)
                expect(connection).to receive(:write).with apns_binary(data, tokens[1], 1)
                pusher.push [notification]
              end

              it 'flushes the socket contents' do
                expect(connection).to receive(:flush).once
                pusher.push [notification]
              end

              describe 'results' do
                before { pusher.push [notification] }

                include_examples 'right results', 2, 0, [NO_ERROR_STATUS_CODE] * 2
              end
            end

            describe 'failure' do

              let(:connection2) { instance_double(APNSConnection).as_null_object }

              before do
                allow(APNSConnection).to receive(:open).with(certificate, sandbox).and_return connection, connection2
              end

              context 'failing first' do
                before do
                  allow(IO).to receive(:select).and_return [[connection]], []
                  allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 0].pack 'ccN'
                end

                it 'sends the each notification once and to the expected connection instance' do
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[0], 0)).once
                  expect(connection2).to receive(:write).with(apns_binary(data, tokens[1], 1)).once
                  pusher.push [notification]
                end

                describe 'results' do
                  before { pusher.push [notification] }

                  include_examples 'right results', 1, 1, [PROCESSING_ERROR_STATUS_CODE, NO_ERROR_STATUS_CODE]
                end
              end

              context 'failing first but delayed error' do
                before do
                  allow(IO).to receive(:select).and_return [], [[connection]], []
                  allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 0].pack 'ccN'
                end

                it 'sends the second notification twice' do
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[0], 0)).once
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[1], 1)).once
                  expect(connection2).to receive(:write).with(apns_binary(data, tokens[1], 1)).once
                  pusher.push [notification]
                end

                describe 'results' do
                  before { pusher.push [notification] }

                  include_examples 'right results', 1, 1, [PROCESSING_ERROR_STATUS_CODE, NO_ERROR_STATUS_CODE]
                end
              end

              context 'failing last' do
                before do
                  allow(IO).to receive(:select).and_return [], [[connection]]
                  allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 1].pack 'ccN'
                end

                it 'sends the second notification just once' do
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[0], 0)).once
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[1], 1)).once
                  expect(connection2).to_not receive(:write)
                  pusher.push [notification]
                end

                describe 'results' do
                  before { pusher.push [notification] }

                  include_examples 'right results', 1, 1, [NO_ERROR_STATUS_CODE, PROCESSING_ERROR_STATUS_CODE]
                end
              end
            end
          end
        end

        context 'several notifications' do
          let(:tokens) { (0...10).map { generate:apns_token } }
          let(:notifications) { tokens.map { |token| build :apns_notification, data: data, tokens: [token] } }

          describe 'success' do

            before { allow(IO).to receive(:select).and_return [] }

            it 'writes the notifications to the socket' do
              notifications.each_with_index do |notification, i|
                expect(connection).to receive(:write).with(apns_binary(data, tokens[i], i)).once
              end
              pusher.push notifications
            end

            it 'flushes the socket contents' do
              expect(connection).to receive(:flush).once
              pusher.push notifications
            end

            it 'saves results' do
              pusher.push notifications
              expect(notifications.map(&:individual_results)).to eq [[NO_ERROR_STATUS_CODE]] * 10
            end
          end

          describe 'failure' do

            context 'several async failures' do

              let(:connection2) { instance_double(APNSConnection).as_null_object }
              let(:connection3) { instance_double(APNSConnection).as_null_object }
              let(:connection4) { instance_double(APNSConnection).as_null_object }

              before do
                allow(IO).to receive(:select).and_return [], [], [[connection]], [], [], [[connection2]], [], [], [], [], [], [], [[connection3]]
                allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 0].pack('ccN')
                allow(connection2).to receive(:read).with(6).and_return [8, MISSING_DEVICE_TOKEN_STATUS_CODE, 2].pack('ccN')
                allow(connection3).to receive(:read).with(6).and_return [8, INVALID_TOPIC_SIZE_STATUS_CODE, 9].pack('ccN')
                allow(APNSConnection).to receive(:open).with(certificate, sandbox).and_return connection, connection2, connection3, connection4
              end

              it 'repones the connection' do
                (0..2).each do |i|
                  expect(connection).to receive(:write).with(apns_binary(data, tokens[i], i)).once
                end
                expect(connection).to_not receive(:write).with apns_binary(data, tokens[3], 3)

                expect(connection2).to_not receive(:write).with apns_binary(data, tokens[0], 0)
                (1..3).each do |i|
                  expect(connection2).to receive(:write).with(apns_binary(data, tokens[i], i)).once
                end
                expect(connection2).to_not receive(:write).with apns_binary(data, tokens[4], 4)

                expect(connection3).to_not receive(:write).with apns_binary(data, tokens[2], 2)
                (3..9).each do |i|
                  expect(connection3).to receive(:write).with(apns_binary(data, tokens[i], i)).once
                end

                expect(connection4).to_not receive :write
                pusher.push notifications
              end

              it 'saves the statuses' do
                pusher.push notifications
                expect(notifications.map(&:individual_results)).to eq [
                    [PROCESSING_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [MISSING_DEVICE_TOKEN_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [INVALID_TOPIC_SIZE_STATUS_CODE]
                  ]
              end
            end

            context 'several sync failures' do

              let(:connection2) { instance_double(APNSConnection).as_null_object }
              let(:connection3) { instance_double(APNSConnection).as_null_object }
              let(:connection4) { instance_double(APNSConnection).as_null_object }

              before do
                allow(IO).to receive(:select).and_return [[connection]], [], [[connection2]], [], [], [], [], [], [], [[connection3]]
                allow(connection).to receive(:read).with(6).and_return [8, PROCESSING_ERROR_STATUS_CODE, 0].pack('ccN')
                allow(connection2).to receive(:read).with(6).and_return [8, MISSING_DEVICE_TOKEN_STATUS_CODE, 2].pack('ccN')
                allow(connection3).to receive(:read).with(6).and_return [8, INVALID_TOPIC_SIZE_STATUS_CODE, 9].pack('ccN')
                allow(APNSConnection).to receive(:open).with(certificate, sandbox).and_return connection, connection2, connection3, connection4
              end

              it 'repones the connection' do
                expect(connection).to receive(:write).with(apns_binary(data, tokens[0], 0)).once
                expect(connection).to_not receive(:write).with apns_binary(data, tokens[1], 1)

                expect(connection2).to_not receive(:write).with apns_binary(data, tokens[0], 0)
                (1..2).each do |i|
                  expect(connection2).to receive(:write).with(apns_binary(data, tokens[i], i)).once
                end
                expect(connection2).to_not receive(:write).with apns_binary(data, tokens[3], 3)

                expect(connection3).to_not receive(:write).with apns_binary(data, tokens[2], 2)
                (3..9).each do |i|
                  expect(connection3).to receive(:write).with(apns_binary(data, tokens[i], i)).once
                end

                expect(connection4).to_not receive :write
                pusher.push notifications
              end

              it 'saves the statuses' do
                pusher.push notifications
                expect(notifications.map(&:individual_results)).to eq [
                    [PROCESSING_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [MISSING_DEVICE_TOKEN_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [NO_ERROR_STATUS_CODE],
                    [INVALID_TOPIC_SIZE_STATUS_CODE]
                  ]
              end
            end
          end
        end
      end
    end
  end
end
