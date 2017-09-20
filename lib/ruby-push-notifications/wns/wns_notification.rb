require 'builder'

module RubyPushNotifications
  module WNS
    # Encapsulates a WNS Notification.
    # Actually support for raw, toast, tiles notifications
    # (http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945)
    #
    class WNSNotification
      include RubyPushNotifications::NotificationResultsManager

      # @return [Hash]. Payload to send.
      #   Toast :title => a bold message
      #     :message => the small message
      #     :param => a string parameter that is passed to the app
      #   Tile :image => a new image for the tile
      #     :count => a number to show on the tile
      #     :title => the new title of the tile
      #     :back_image => an image for the back of the tile
      #     :back_title => a title on the back of the tile
      #     :back_content => some content (text) for the back
      #   Raw :message => the full Hash message body
      attr_reader :data

      # @return [Array]. Array with the receiver's WNS device URLs.
      attr_reader :device_urls

      # Initializes the notification
      #
      # @param [Array]. Array with the receiver's device urls.
      # @param [Hash]. Payload to send.
      #   Toast :title => a bold message
      #     :message => the small message
      #     :param => a string parameter that is passed to the app
      #   Tile :image => a new image for the tile
      #     :count => a number to show on the tile
      #     :title => the new title of the tile
      #     :back_image => an image for the back of the tile
      #     :back_title => a title on the back of the tile
      #     :back_content => some content (text) for the back
      #   Raw :message => the full XML message body
      def initialize(device_urls, data)
        @device_urls = device_urls
        @data = data
        @data[:type] ||= :raw
      end

      # @return [String]. The WNS's XML format for the payload to send.
      # (https://docs.microsoft.com/en-us/uwp/schemas/tiles/tiles-xml-schema-portal)
      def as_wns_xml
        xml = Builder::XmlMarkup.new
        xml.instruct!
        if data[:type] != :raw
          case data[:type]
          when :toast
            xml.tag!('toast', **launch_params(data)) do
              xml.tag!('visual') do
                xml.tag!('binding', template: data[:template] || 'ToastText02') do
                  xml.tag!('text', id: 1) { xml.text!(data[:title].to_s) }
                  xml.tag!('text', id: 2) { xml.text!(data[:message].to_s) }
                end
              end
            end
          when :tile
            xml.tag!('tile') do
              xml.tag!('visual') do
                xml.tag!('binding', template: data[:template] || 'TileWideImageAndText01') do
                  xml.tag!('image', src: data[:image].to_s)
                  xml.tag!('text') { xml.text!(data[:message].to_s) }
                end
              end
            end
          when :badge
            xml.tag!('badge', value: data[:value])
          end
        else
          xml.root { build_hash(xml, data[:message]) }
        end
        xml.target!
      end

      def each_device
        @device_urls.each do |url|
          yield(URI.parse url)
        end
      end

      def build_hash(xml, options)
        return unless options
        options.each do |k, v|
          xml.tag!(k.to_s) { v.is_a?(Hash) ? build_hash(xml, v) : xml.text!(v.to_s) }
        end
      end

      def launch_params(data)
        return {} unless data[:param]
        { launch: data[:param].to_json }
      end
    end
  end
end
