module Karaden
  module Model
    class Requestable < KaradenObject
      def self.requestor
        @@requestor
      end

      def self.requestor=(val)
        @@requestor = val
      end

      def self.request(method, path, content_type = nil, params = nil, data = nil, request_options = nil)
        response = @@requestor.send(method, path, content_type, params, data, request_options)
        raise response.error if response.error?

        response.object
      end
    end
  end
end

Karaden::Model::Requestable.requestor = Karaden::Net::Requestor.new
