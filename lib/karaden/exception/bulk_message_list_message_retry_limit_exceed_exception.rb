module Karaden
  module Exception
    class BulkMessageListMessageRetryLimitExceedException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
