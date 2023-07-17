module Karaden
  module Exception
    class UnauthorizedException < KaradenException
      STATUS_CODE = 401
      def initialize(message = nil)
        super
      end
    end
  end
end
