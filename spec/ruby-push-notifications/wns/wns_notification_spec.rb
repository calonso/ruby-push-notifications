module RubyPushNotifications
  module WNS
    describe WNSNotification do

      let(:device_urls) { %w(a b c) }
      let(:raw_notification) { build :wns_notification }
      let(:toast_data) { { title: 'Title', message: 'Hello WNS World!', type: :toast } }
      let(:toast_notification) { build :wns_notification, device_urls: device_urls, data: toast_data }
      let(:tile_data) { { message: 'Hello WNS World!', image: 'http://image.com/image.jpg', type: :tile } }
      let(:tile_notification) { build :wns_notification, device_urls: device_urls, data: tile_data }
      let(:badge_data) { { value: 10, type: :badge } }
      let(:badge_notification) { build :wns_notification, device_urls: device_urls, data: badge_data }

      it 'builds the right wns raw xml' do
        xml = '<?xml version="1.0" encoding="UTF-8"?>'
        xml << '<root><value1>hello</value1></root>'
        expect(raw_notification.as_wns_xml).to eq xml
      end

      it 'builds the right wns badge xml' do
        xml = '<?xml version="1.0" encoding="UTF-8"?>'
        xml << '<badge value="10"/>'
        expect(badge_notification.as_wns_xml).to eq xml
      end

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

      it 'validates the wns format'

      it 'validates the data'

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
