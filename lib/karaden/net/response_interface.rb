module Karaden
  module Net
    class ResponseInterface
      def error()
        raise NotImplementedError
      end

      def object()
        raise NotImplementedError
      end

      def error?()
        raise NotImplementedError
      end
    end
  end
end
