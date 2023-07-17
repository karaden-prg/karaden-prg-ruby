module Karaden
  module Exception
    class NotFoundException < KaradenException
      STATUS_CODE = 404
      def initialize(message = nil)
        super
      end
    end
  end
end
