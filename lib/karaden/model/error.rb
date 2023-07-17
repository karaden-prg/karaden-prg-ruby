module Karaden
  module Model
    class Error < KaradenObject
      OBJECT_NAME = 'error'.freeze

      def code()
        property('code')
      end

      def message()
        property('message')
      end

      def errors()
        property('errors')
      end
    end
  end
end
