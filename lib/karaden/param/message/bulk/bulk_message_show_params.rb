module Karaden
  module Param
    module Message
      module Bulk
        class BulkMessageShowParams < BulkMessageParams
          attr_accessor :id

          def initialize()
            @id = nil
            super
          end

          def to_path
            "#{CONTEXT_PATH}/#{@id}"
          end

          def validate
            errors = Karaden::Model::KaradenObject.new
            has_error = false

            messages = validate_id
            unless messages.empty?
              errors.set_property('id', messages)
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
            BulkMessageShowParamsBuilder.new
          end

          protected

          def validate_id
            messages = []
            if @id.nil? || @id == ''
              messages << 'idは必須です。'
              messages << '文字列（UUID）を入力してください。'
            end
            messages
          end
        end

        class BulkMessageShowParamsBuilder
          def initialize
            @params = BulkMessageShowParams.new
          end

          def with_id(id)
            @params.id = id
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
