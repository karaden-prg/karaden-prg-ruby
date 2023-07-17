module Karaden
  module Exception
    class BadRequestException < KaradenException
      STATUS_CODE = 400
      def initialize(message = nil)
        super
      end
    end
  end
end
