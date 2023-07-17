module Karaden
  module Model
    class KaradenObject
      def initialize(id = nil, request_options = nil)
        @properties = {}
        @request_options = request_options
        set_property('id', id)
      end

      def id()
        property('id')
      end

      def object()
        property('object')
      end

      def set_property(key, value)
        @properties[key] = value
      end

      def property_keys()
        @properties.keys
      end

      def property(key)
        @properties[key]
      end
    end
  end
end
