module Karaden
  module Param
    module Message
      class MessageParams
        CONTEXT_PATH = '/messages'.freeze
        def validate()
          self
        end
      end
    end
  end
end
