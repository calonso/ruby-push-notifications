
module RubyPushNotifications
  module MPNS
    # Encapsulates a MPNS Notification.
    # Actually support for raw, toast, tiles notifications
    # (http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945)
    #
    class MPNSNotification

      # @return [Array]. Array with the results from sending this notification
      attr_accessor :results, :data, :device_urls

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
        @data[:type] ||= 'raw'

        @data[:type] = @data[:type].to_sym
        @data[:delay] = @data[:delay].to_sym if @data[:delay]
      end


      # @return [String]. The GCM's XML format for the payload to send.
      # (http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945)
      def as_mpns_xml
        wp_type = data[:type].to_s.capitalize
        body = "<?xml version='1.0' encoding='utf-8'?>"
        if data[:type] != :raw
          body << "<wp:Notification xmlns:wp='WPNotification'><wp:#{wp_type}>"
          case data[:type]
          when :toast
            body << "<wp:Text1>#{data[:title]}</wp:Text1>"
            body << "<wp:Text2>#{data[:message]}</wp:Text2>"
            body << "<wp:Param>#{data[:param]}</wp:Param>" if data[:param]
          when :tile
            body << "<wp:BackgroundImage>#{data[:image]}</wp:BackgroundImage>" if data[:image]
            body << "<wp:Count>#{data[:count]}</wp:Count>" if data[:count]
            body << "<wp:Title>#{data[:title]}</wp:Title>" if data[:title]
            body << "<wp:BackBackgroundImage>#{data[:back_image]}</wp:BackBackgroundImage>" if data[:back_image]
            body << "<wp:BackTitle>#{data[:back_title]}</wp:BackTitle>" if data[:back_title]
            body << "<wp:BackContent>#{data[:back_content]}</wp:BackContent>" if data[:back_content]
          end
          body << "</wp:#{wp_type}></wp:Notification>"
        else
          body << "#{data[:message]}"
        end
        body
      end

    end
  end
end
