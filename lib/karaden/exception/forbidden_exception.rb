module Karaden
  module Exception
    class ForbiddenException < KaradenException
      STATUS_CODE = 403
      def initialize(message = nil)
        super
      end
    end
  end
end
