module RubyPushNotifications
  module WNS
    describe WNSNotification do
      let(:device_urls) { %w(a b c) }
      let(:raw_data) { { message: { title: 'Title', message: 'Hello WNS World!'} } }
      let(:raw_notification) { build :wns_notification, data: raw_data }
      let(:toast_data) { { title: 'Title', message: 'Hello WNS World!', type: :toast } }
      let(:toast_notification) { build :wns_notification, device_urls: device_urls, data: toast_data }
      let(:tile_data) { { message: 'Hello WNS World!', image: 'http://image.com/image.jpg', type: :tile } }
      let(:tile_notification) { build :wns_notification, device_urls: device_urls, data: tile_data }
      let(:badge_data) { { value: 10, type: :badge } }
      let(:badge_notification) { build :wns_notification, device_urls: device_urls, data: badge_data }

      describe 'raw xml' do
        it 'builds the right wns raw xml' do
          xml = '<?xml version="1.0" encoding="UTF-8"?>'
          xml << '<root><title>Title</title><message>Hello WNS World!</message></root>'
          expect(raw_notification.as_wns_xml).to eq xml
        end

        context 'without message' do
          let(:raw_data) { {} }

          it 'builds the right wns raw xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<root></root>'
            expect(raw_notification.as_wns_xml).to eq xml
          end
        end
      end

      describe 'badge xml' do
        it 'builds the right wns badge xml' do
          xml = '<?xml version="1.0" encoding="UTF-8"?>'
          xml << '<badge value="10"/>'
          expect(badge_notification.as_wns_xml).to eq xml
        end

        context 'without value' do
          let(:badge_data) { { type: :badge } }

          it 'builds the right wns badge xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<badge value=""/>'
            expect(badge_notification.as_wns_xml).to eq xml
          end
        end
      end

      describe 'toast xml' do
        it 'builds the right wns toast xml' do
          xml = '<?xml version="1.0" encoding="UTF-8"?>'
          xml << '<toast>'
          xml << '<visual>'
          xml << '<binding template="ToastText02">'
          xml << '<text id="1">Title</text>'
          xml << '<text id="2">Hello WNS World!</text>'
          xml << '</binding>'
          xml << '</visual>'
          xml << '</toast>'
          expect(toast_notification.as_wns_xml).to eq xml
        end

        context 'when params present' do
          let(:toast_data) { super().merge(param: { var1: 'value1', var2: 'value2'}) }

          it 'builds the right wns toast xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<toast launch="{&quot;var1&quot;:&quot;value1&quot;,&quot;var2&quot;:&quot;value2&quot;}">'
            xml << '<visual>'
            xml << '<binding template="ToastText02">'
            xml << '<text id="1">Title</text>'
            xml << '<text id="2">Hello WNS World!</text>'
            xml << '</binding>'
            xml << '</visual>'
            xml << '</toast>'
            expect(toast_notification.as_wns_xml).to eq xml
          end
        end

        context 'when template present' do
          let(:toast_data) { super().merge(template: 'custom_template') }

          it 'builds the right wns toast xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<toast>'
            xml << '<visual>'
            xml << '<binding template="custom_template">'
            xml << '<text id="1">Title</text>'
            xml << '<text id="2">Hello WNS World!</text>'
            xml << '</binding>'
            xml << '</visual>'
            xml << '</toast>'
            expect(toast_notification.as_wns_xml).to eq xml
          end
        end

        context 'without title and message' do
          let(:toast_data) { { type: :toast } }

          it 'builds the right wns toast xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<toast>'
            xml << '<visual>'
            xml << '<binding template="ToastText02">'
            xml << '<text id="1"></text>'
            xml << '<text id="2"></text>'
            xml << '</binding>'
            xml << '</visual>'
            xml << '</toast>'
            expect(toast_notification.as_wns_xml).to eq xml
          end
        end
      end

      describe 'toast xml' do
        it 'builds the right wns tile xml' do
          xml = '<?xml version="1.0" encoding="UTF-8"?>'
          xml << '<tile>'
          xml << '<visual>'
          xml << '<binding template="TileWideImageAndText01">'
          xml << '<image src="http://image.com/image.jpg"/>'
          xml << '<text>Hello WNS World!</text>'
          xml << '</binding>'
          xml << '</visual>'
          xml << '</tile>'
          expect(tile_notification.as_wns_xml).to eq xml
        end

        context 'when template present' do
          let(:tile_data) { super().merge(template: 'custom_template') }

          it 'builds the right wns toast xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<tile>'
            xml << '<visual>'
            xml << '<binding template="custom_template">'
            xml << '<image src="http://image.com/image.jpg"/>'
            xml << '<text>Hello WNS World!</text>'
            xml << '</binding>'
            xml << '</visual>'
            xml << '</tile>'
            expect(tile_notification.as_wns_xml).to eq xml
          end
        end

        context 'without image and message' do
          let(:tile_data) { { type: :tile } }

          it 'builds the right wns toast xml' do
            xml = '<?xml version="1.0" encoding="UTF-8"?>'
            xml << '<tile>'
            xml << '<visual>'
            xml << '<binding template="TileWideImageAndText01">'
            xml << '<image src=""/>'
            xml << '<text></text>'
            xml << '</binding>'
            xml << '</visual>'
            xml << '</tile>'
            expect(tile_notification.as_wns_xml).to eq xml
          end
        end
      end

      it_behaves_like 'a proper results manager' do
        let(:notification) { build :wns_notification }
        let(:success_count) { 1 }
        let(:failures_count) { 0 }
        let(:device_url) { generate :wns_device_url }
        let(:individual_results) { [WNSResultOK.new(device_url, {})] }
        let(:results) do
          WNSResponse.new [{ code: 200, device_url: device_url, headers: {} }]
        end
      end
    end
  end
end
