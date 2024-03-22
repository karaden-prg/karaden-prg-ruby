module Karaden
  class Utility
    OBJECT_TYPES = {
      Karaden::Model::Error::OBJECT_NAME => Karaden::Model::Error,
      Karaden::Model::Collection::OBJECT_NAME => Karaden::Model::Collection,
      Karaden::Model::Message::OBJECT_NAME => Karaden::Model::Message,
      Karaden::Model::BulkFile::OBJECT_NAME => Karaden::Model::BulkFile,
      Karaden::Model::BulkMessage::OBJECT_NAME => Karaden::Model::BulkMessage
    }.freeze
    DEFAULT_CONNECTION_TIMEOUT = 10
    DEFAULT_READ_TIMEOUT = 30

    def self.convert_to_karaden_object(contents, request_options)
      clazz = OBJECT_TYPES[contents['object']] || Karaden::Model::KaradenObject
      construct_from(clazz, contents, request_options)
    end

    def self.construct_from(clazz, contents, request_options)
      object = clazz.new(contents['id'], request_options)
      contents.each_pair do |key, value|
        v = if value.is_a?(Array)
              convert_to_array(value, request_options)
            elsif value.is_a?(Hash)
              convert_to_karaden_object(value, request_options)
            else
              value
            end
        object.set_property(key, v)
      end
      object
    end

    def self.convert_to_array(contents, request_options)
      contents.map do |v|
        v.is_a?(Hash) ? convert_to_karaden_object(v, request_options) : v
      end
    end

    def self.put_signed_url(signed_url, filename, content_type = 'application/octet-stream', request_options = nil)
      uri = URI.parse(signed_url)
      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.open_timeout, http.read_timeout = get_timeout(request_options)

      request = ::Net::HTTP::Put.new(uri.request_uri)
      response = File.open(filename, 'rb') do |f|
        request.body_stream = f
        request['Content-Length'] = f.size
        request['Content-Type'] = content_type

        http.request(request)
      end

      raise Karaden::Exception::FileUploadFailedException unless response.code == '200'
    rescue Karaden::Exception::FileUploadFailedException
      raise
    rescue StandardError
      raise Karaden::Exception::FileUploadFailedException
    end

    def self.get_timeout(request_options = nil)
      [request_options&.connection_timeout || DEFAULT_CONNECTION_TIMEOUT, request_options&.read_timeout || DEFAULT_READ_TIMEOUT]
    end
  end
end
