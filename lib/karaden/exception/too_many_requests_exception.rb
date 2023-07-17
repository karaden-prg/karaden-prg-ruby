module Karaden
  module Exception
    class TooManyRequestsException < KaradenException
      STATUS_CODE = 429
      def initialize(message = nil)
        super
      end
    end
  end
end
