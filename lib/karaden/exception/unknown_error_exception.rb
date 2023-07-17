module Karaden
  module Exception
    class UnknownErrorException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
