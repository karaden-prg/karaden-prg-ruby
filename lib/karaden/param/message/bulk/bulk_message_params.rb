module Karaden
  module Param
    module Message
      module Bulk
        class BulkMessageParams
          CONTEXT_PATH = '/messages/bulks'.freeze

          def validate()
            self
          end
        end
      end
    end
  end
end
