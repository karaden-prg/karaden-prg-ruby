module Karaden
  module Service
    class BulkMessageService
      REGEX_PATTERN = /filename="([^"]+)"/.freeze

      def self.create(filename, request_options = nil)
        raise Karaden::Exception::FileNotFoundException unless File.file?(filename)

        bulk_file = Karaden::Model::BulkFile.create(request_options)

        Karaden::Utility.put_signed_url(bulk_file.url, filename, 'text/csv', request_options)

        params = Karaden::Param::Message::Bulk::BulkMessageCreateParams
                   .new_builder
                   .with_bulk_file_id(bulk_file.id)
                   .build
        Karaden::Model::BulkMessage.create(params, request_options)
      end

      def self.download(params, request_options = nil)
        params.validate
        show_params = Karaden::Param::Message::Bulk::BulkMessageShowParams.new_builder
          .with_id(params.id)
          .build
        unless Karaden::Service::BulkMessageService.check_bulk_message_status(params.max_retries, params.retry_interval, show_params, request_options)
          raise Exception::BulkMessageShowRetryLimitExceedException
        end

        list_message_params = Param::Message::Bulk::BulkMessageListMessageParams.new_builder
          .with_id(params.id)
          .build
        download_url = Karaden::Service::BulkMessageService.get_download_url(params.max_retries, params.retry_interval, list_message_params, request_options)
        raise Exception::BulkMessageListMessageRetryLimitExceedException if download_url.nil?

        begin
          Karaden::Service::BulkMessageService.get_contents(download_url, params.directory_path, request_options)
        rescue StandardError
          raise Exception::FileDownloadFailedException
        end
      end

      def self.get_contents(download_url, directory_path, request_options = nil)
        uri = URI.parse(download_url)
        http = ::Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.open_timeout, http.read_timeout = Karaden::Utility.get_timeout(request_options)
        http.request_get(uri.request_uri) do |response|
          match = response['content-disposition'].match(Karaden::Service::BulkMessageService::REGEX_PATTERN)
          raise Exception::FileDownloadFailedException unless match

          filename = File.join(File.realpath(directory_path), match[1])
          File.open(filename, 'w') do |file|
            response.read_body do |chunk|
              file.write(chunk)
            end
          end
        end
        true
      end

      def self.check_bulk_message_status(retry_count, retry_interval, params, request_options)
        result = false
        (0..retry_count).each do |count|
          # sleep retry_interval if count.positive?
          bulk_message = Karaden::Model::BulkMessage.show(params, request_options)
          raise Exception::BulkMessageCreateFailedException if bulk_message.status == Karaden::Model::BulkMessage::STATUS_ERROR

          if bulk_message.status == Karaden::Model::BulkMessage::STATUS_DONE
            result = true
            break
          end
        end
        result
      end

      def self.get_download_url(retry_count, retry_interval, params, request_options)
        result = nil
        (0..retry_count).each do |count|
          # sleep retry_interval if count.positive?
          output = Karaden::Model::BulkMessage.list_message(params, request_options)
          unless output.nil?
            result = output
            break
          end
        end
        result
      end
    end
  end
end
