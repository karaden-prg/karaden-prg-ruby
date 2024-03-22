module Karaden
  module Exception
    class FileDownloadFailedException < KaradenException
      def initialize(message = nil)
        super
      end
    end
  end
end
