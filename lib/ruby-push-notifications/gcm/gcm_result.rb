
module RubyPushNotifications
  module GCM
    class GCMResult ; end

    class GCMResultOK < GCMResult

      def ==(other)
        other.is_a?(GCMResultOK) || super(other)
      end
    end

    class GCMCanonicalIDResult < GCMResult
      attr_reader :canonical_id

      def initialize(canonical_id)
        @canonical_id = canonical_id
      end

      def ==(other)
        (other.is_a?(GCMCanonicalIDResult) && @canonical_id == other.canonical_id) ||
        super(other)
      end
    end

    class GCMResultError < GCMResult
      attr_accessor :error

      def initialize(error)
        @error = error
      end

      def ==(other)
        (other.is_a?(GCMResultError) && @error == other.error) || super(other)
      end
    end
  end
end
