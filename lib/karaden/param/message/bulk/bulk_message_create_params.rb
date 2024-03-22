module Karaden
  module Param
    module Message
      module Bulk
        class BulkMessageCreateParams < BulkMessageParams
          attr_accessor :bulk_file_id

          def initialize()
            @bulk_file_id = nil
            super
          end

          def to_path
            CONTEXT_PATH
          end

          def to_data
            {
              bulk_file_id: @bulk_file_id
            }.reject { |_, value| value.nil? }
          end

          def validate
            errors = Karaden::Model::KaradenObject.new
            has_error = false

            messages = validate_bulk_file_id
            unless messages.empty?
              errors.set_property('bulk_file_id', messages)
              has_error = true
            end

            if has_error
              e = Karaden::Exception::InvalidParamsException.new
              error = Karaden::Model::Error.new
              error.set_property('object', Karaden::Model::Error::OBJECT_NAME)
              error.set_property('errors', errors)
              e.error = error
              raise e
            end

            self
          end

          def self.new_builder
            BulkMessageCreateParamsBuilder.new
          end

          protected

          def validate_bulk_file_id
            messages = []
            if @bulk_file_id.nil? || @bulk_file_id == ''
              messages << 'bulk_file_idは必須です。'
              messages << '文字列（UUID）を入力してください。'
            end
            messages
          end
        end

        class BulkMessageCreateParamsBuilder
          def initialize
            @params = BulkMessageCreateParams.new
          end

          def with_bulk_file_id(bulk_file_id)
            @params.bulk_file_id = bulk_file_id
            self
          end

          def build
            @params.clone
          end
        end
      end
    end
  end
end

