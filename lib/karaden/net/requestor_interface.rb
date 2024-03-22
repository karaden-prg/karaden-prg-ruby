module Karaden
  module Net
    class RequestorInterface
      def send(method, path, content_type = nil, params = nil, data = nil, request_options = nil, is_no_contents = false)
        raise NotImplementedError
      end
    end
  end
end
