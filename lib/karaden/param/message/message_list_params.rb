module Karaden
  module Param
    module Message
      class MessageListParams < MessageParams
        attr_accessor :service_id, :to, :status, :result, :sent_result, :tag, :start_at, :end_at, :page, :per_page

        def initialize()
          @service_id = nil
          @to = nil
          @status = nil
          @result = nil
          @sent_result = nil
          @tag = nil
          @start_at = nil
          @end_at = nil
          @page = nil
          @per_page = nil
          super
        end

        def to_path
          CONTEXT_PATH
        end

        def to_params
          {
            service_id: @service_id,
            to: @to,
            status: @status,
            result: @result,
            sent_result: @sent_result,
            tag: @tag,
            start_at: @start_at&.iso8601,
            end_at: @end_at&.iso8601,
            page: @page,
            per_page: @per_page
          }.reject { |_, value| value.nil? }
        end

        def self.new_builder
          MessageListParamsBuilder.new
        end
      end

      class MessageListParamsBuilder
        def initialize
          @params = MessageListParams.new
        end

        def with_service_id(service_id)
          @params.service_id = service_id
          self
        end

        def with_to(to)
          @params.to = to
          self
        end

        def with_status(status)
          @params.status = status
          self
        end

        def with_result(result)
          @params.result = result
          self
        end

        def with_sent_result(sent_result)
          @params.sent_result = sent_result
          self
        end

        def with_tag(tag)
          @params.tag = tag
          self
        end

        def with_start_at(start_at)
          @params.start_at = start_at
          self
        end

        def with_end_at(end_at)
          @params.end_at = end_at
          self
        end

        def with_page(page)
          @params.page = page
          self
        end

        def with_per_page(per_page)
          @params.per_page = per_page
          self
        end

        def build
          @params.clone
        end
      end
    end
  end
end
