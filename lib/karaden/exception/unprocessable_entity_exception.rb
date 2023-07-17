module Karaden
  module Exception
    class UnprocessableEntityException < KaradenException
      STATUS_CODE = 422
      def initialize(message = nil)
        super
      end
    end
  end
end
