module Karaden
  module Exception
    class BulkMessageShowRetryLimitExceedException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
