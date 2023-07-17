module Karaden
  module Model
    class Collection < KaradenObject
      OBJECT_NAME = 'list'.freeze

      def data()
        property('data')
      end

      def more?()
        property('has_more')
      end
    end
  end
end
