module Karaden
  module Exception
    class InvalidParamsException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
