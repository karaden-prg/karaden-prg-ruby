module Karaden
  module Model
    class Message < Requestable
      OBJECT_NAME = 'message'.freeze

      def service_id()
        property('service_id')
      end

      def billing_address_id()
        property('billing_address_id')
      end

      def to()
        property('to')
      end

      def body()
        property('body')
      end

      def tags()
        property('tags')
      end

      def shorten?()
        property('is_shorten')
      end

      def result()
        property('result')
      end

      def status()
        property('status')
      end

      def sent_result()
        property('sent_result')
      end

      def carrier()
        property('carrier')
      end

      def scheduled_at()
        scheduled_at = property('scheduled_at')
        begin
          Time.parse(scheduled_at)
        rescue StandardError
          nil
        end
      end

      def limited_at()
        limited_at = property('limited_at')
        begin
          Time.parse(limited_at)
        rescue StandardError
          nil
        end
      end

      def sent_at()
        sent_at = property('sent_at')
        begin
          Time.parse(sent_at)
        rescue StandardError
          nil
        end
      end

      def received_at()
        received_at = property('received_at')
        begin
          Time.parse(received_at)
        rescue StandardError
          nil
        end
      end

      def charged_at()
        charged_at = property('charged_at')
        begin
          Time.parse(charged_at)
        rescue StandardError
          nil
        end
      end

      def created_at()
        created_at = property('created_at')
        begin
          Time.parse(created_at)
        rescue StandardError
          nil
        end
      end

      def updated_at()
        updated_at = property('updated_at')
        begin
          Time.parse(updated_at)
        rescue StandardError
          nil
        end
      end

      def self.create(params, request_options = nil)
        params.validate
        request('POST', params.to_path, 'application/x-www-form-urlencoded', nil, params.to_data, request_options)
      end

      def self.list(params, request_options = nil)
        params.validate
        request('GET', params.to_path, nil, params.to_params, nil, request_options)
      end

      def self.detail(params, request_options = nil)
        params.validate
        request('GET', params.to_path, nil, nil, nil, request_options)
      end

      def self.cancel(params, request_options = nil)
        params.validate
        request('POST', params.to_path, nil, nil, nil, request_options)
      end
    end
  end
end
