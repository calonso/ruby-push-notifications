require 'builder'

module RubyPushNotifications
  module MPNS
    # Encapsulates a MPNS Notification.
    # Actually support for raw, toast, tiles notifications
    # (http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945)
    #
    class MPNSNotification

      # @return [MPNSResponse]. MPNSResponse with the results from sending this notification.
      attr_accessor :results

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

      # @return [Array]. Array with the receiver's MPNS device URLs.
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


      # @return [String]. The GCM's XML format for the payload to send.
      # (http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945)
      def as_mpns_xml
        xml = Builder::XmlMarkup.new
        xml.instruct!
        if data[:type] != :raw
          xml.tag!('wp:Notification', 'xmlns:wp' => 'WPNotification') do
            case data[:type]
            when :toast
              xml.tag!('wp:Toast') do
                xml.tag!('wp:Text1') { xml.text!(data[:title]) }
                xml.tag!('wp:Text2') { xml.text!(data[:message]) }
                xml.tag!('wp:Param') { xml.text!(data[:param]) } if data[:param]
              end
            when :tile
              xml.tag!('wp:Tile') do
                xml.tag!('wp:BackgroundImage') { xml.text!(data[:image]) } if data[:image]
                xml.tag!('wp:Count') { xml.text!(data[:count].to_s) } if data[:count]
                xml.tag!('wp:Title') { xml.text!(data[:title]) } if data[:title]
                xml.tag!('wp:BackBackgroundImage') { xml.text!(data[:back_image]) } if data[:back_image]
                xml.tag!('wp:BackTitle') { xml.text!(data[:back_title]) } if data[:back_title]
                xml.tag!('wp:BackContent') { xml.text!(data[:back_content]) } if data[:back_content]
              end
            end
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
        options.each do |k, v|
          xml.tag!(k.to_s) { v.is_a?(Hash) ? build_hash(xml, v) : xml.text!(v.to_s) }
        end
      end

    end
  end
end
