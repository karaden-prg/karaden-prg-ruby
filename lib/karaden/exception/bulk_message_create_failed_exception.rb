module Karaden
  module Exception
    class BulkMessageCreateFailedException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
