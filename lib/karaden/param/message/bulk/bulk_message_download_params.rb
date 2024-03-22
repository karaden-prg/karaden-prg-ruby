module Karaden
  module Param
    module Message
      module Bulk
        class BulkMessageDownloadParams < BulkMessageParams
          attr_accessor :id, :directory_path, :max_retries, :retry_interval

          DEFAULT_MAX_RETRIES = 2
          MAX_MAX_RETRIES = 5
          MIN_MAX_RETRIES = 1
          DEFAULT_RETRY_INTERVAL = 20
          MAX_RETRY_INTERVAL = 60
          MIN_RETRY_INTERVAL = 10

          def initialize()
            @id = nil
            @directory_path = nil
            @max_retries = DEFAULT_MAX_RETRIES
            @retry_interval = DEFAULT_RETRY_INTERVAL
            super
          end

          def validate
            errors = Karaden::Model::KaradenObject.new
            has_error = false

            messages = validate_id
            unless messages.empty?
              errors.set_property('id', messages)
              has_error = true
            end

            messages = validate_directory_path
            unless messages.empty?
              errors.set_property('directory_path', messages)
              has_error = true
            end

            messages = validate_max_retries
            unless messages.empty?
              errors.set_property('max_retries', messages)
              has_error = true
            end

            messages = validate_retry_interval
            unless messages.empty?
              errors.set_property('retry_interval', messages)
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
            BulkMessageDownloadParamsBuilder.new
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

          def validate_directory_path
            messages = []
            if @directory_path.nil? || @directory_path == ''
              messages << 'directory_pathは必須です。'
              messages << '文字列を入力してください。'
            else
              messages << '指定されたディレクトリパスが存在しません。' unless Dir.exist?(@directory_path)
              messages << '指定されたパスはディレクトリではありません。' unless File.directory?(@directory_path)
              messages << '指定されたディレクトリには読み取り権限がありません。' unless File.readable?(@directory_path)
              messages << '指定されたディレクトリには書き込み権限がありません。' unless File.writable?(@directory_path)
            end
            messages
          end

          def validate_max_retries
            messages = []
            messages << "max_retriesには#{MIN_MAX_RETRIES}以上の整数を入力してください。" if @max_retries.nil? || !@max_retries.is_a?(Integer) || @max_retries < MIN_MAX_RETRIES
            messages << "max_retriesには#{MAX_MAX_RETRIES}以下の整数を入力してください。" if @max_retries.nil? || !@max_retries.is_a?(Integer) || @max_retries > MAX_MAX_RETRIES
            messages
          end

          def validate_retry_interval
            messages = []
            messages << "retry_intervalには#{MIN_RETRY_INTERVAL}以上の整数を入力してください。" if @retry_interval.nil? || !@retry_interval.is_a?(Integer) || @retry_interval < MIN_RETRY_INTERVAL
            messages << "retry_intervalには#{MAX_RETRY_INTERVAL}以下の整数を入力してください。" if @retry_interval.nil? || !@retry_interval.is_a?(Integer) || @retry_interval > MAX_RETRY_INTERVAL
            messages
          end
        end

        class BulkMessageDownloadParamsBuilder
          def initialize
            @params = BulkMessageDownloadParams.new
          end

          def with_id(id)
            @params.id = id
            self
          end

          def with_directory_path(directory_path)
            @params.directory_path = directory_path
            self
          end

          def with_max_retries(max_retries)
            @params.max_retries = max_retries
            self
          end

          def with_retry_interval(retry_interval)
            @params.retry_interval = retry_interval
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
