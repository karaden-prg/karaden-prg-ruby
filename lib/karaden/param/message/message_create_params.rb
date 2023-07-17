module Karaden
  module Param
    module Message
      class MessageCreateParams < MessageParams
        attr_accessor :service_id, :to, :body, :tags, :is_shorten, :scheduled_at, :limited_at

        def initialize()
          @service_id = nil
          @to = nil
          @body = nil
          @tags = nil
          @is_shorten = nil
          @scheduled_at = nil
          @limited_at = nil
          super
        end

        def to_path
          CONTEXT_PATH
        end

        def to_data
          {
            service_id: @service_id,
            to: @to,
            body: @body,
            'tags[]' => @tags,
            is_shorten: if @is_shorten.nil?
                          nil
                        else
                          @is_shorten ? 'true' : 'false'
                        end,
            scheduled_at: @scheduled_at&.iso8601,
            limited_at: @limited_at&.iso8601
          }.reject { |_, value| value.nil? }
        end

        def validate
          errors = Karaden::Model::KaradenObject.new
          has_error = false

          messages = validate_service_id
          unless messages.empty?
            errors.set_property('service_id', messages)
            has_error = true
          end

          messages = validate_to
          unless messages.empty?
            errors.set_property('to', messages)
            has_error = true
          end

          messages = validate_body
          unless messages.empty?
            errors.set_property('body', messages)
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
          MessageCreateParamsBuilder.new
        end

        protected

        def validate_service_id
          messages = []
          if @service_id.nil? || @service_id == ''
            messages << 'service_idは必須です。'
            messages << '数字を入力してください。'
          end
          messages
        end

        def validate_to
          messages = []
          if @to.nil? || @to == ''
            messages << 'toは必須です。'
            messages << '文字列を入力してください。'
          end
          messages
        end

        def validate_body
          messages = []
          if @body.nil? || @body == ''
            messages << 'bodyは必須です。'
            messages << '文字列を入力してください。'
          end
          messages
        end
      end

      class MessageCreateParamsBuilder
        def initialize
          @params = MessageCreateParams.new
        end

        def with_service_id(service_id)
          @params.service_id = service_id
          self
        end

        def with_to(to)
          @params.to = to
          self
        end

        def with_body(body)
          @params.body = body
          self
        end

        def with_tags(tags)
          @params.tags = tags
          self
        end

        def with_is_shorten(is_shorten)
          @params.is_shorten = is_shorten
          self
        end

        def with_scheduled_at(scheduled_at)
          @params.scheduled_at = scheduled_at
          self
        end

        def with_limited_at(limited_at)
          @params.limited_at = limited_at
          self
        end

        def build
          @params.clone
        end
      end
    end
  end
end
