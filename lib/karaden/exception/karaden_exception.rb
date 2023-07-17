module Karaden
  module Exception
    class KaradenException < StandardError
      attr_accessor :code, :headers, :body, :error

      def initialize(message = nil)
        @code = nil
        @headers = {}
        @body = ''
        @error = nil
        super(message)
      end
    end
  end
end
