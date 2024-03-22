module Karaden
  module Model
    class BulkFile < Requestable
      OBJECT_NAME = 'bulk_file'.freeze

      def url()
        property('url')
      end

      def created_at()
        created_at = property('created_at')
        begin
          Time.parse(created_at)
        rescue StandardError
          nil
        end
      end

      def expires_at()
        expires_at = property('expires_at')
        begin
          Time.parse(expires_at)
        rescue StandardError
          nil
        end
      end

      def self.create(request_options = nil)
        path = "#{Karaden::Param::Message::Bulk::BulkMessageParams::CONTEXT_PATH}/files"
        request('POST', path, nil, nil, nil, request_options)
      end
    end
  end
end
