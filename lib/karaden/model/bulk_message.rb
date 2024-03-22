module Karaden
  module Model
    class BulkMessage < Requestable
      OBJECT_NAME = 'bulk_message'.freeze
      STATUS_DONE = 'done'.freeze
      STATUS_WAITING = 'waiting'.freeze
      STATUS_PROCESSING = 'processing'.freeze
      STATUS_ERROR = 'error'.freeze

      def status()
        property('status')
      end

      def error()
        property('error')
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

      def self.show(params, request_options = nil)
        params.validate
        request('GET', params.to_path, nil, nil, nil, request_options)
      end

      def self.list_message(params, request_options = nil)
        params.validate
        response = request_and_return_response_interface('GET', params.to_path, nil, nil, nil, request_options)
        response.status_code == 302 ? response.headers['location'] : nil
      end
    end
  end
end
