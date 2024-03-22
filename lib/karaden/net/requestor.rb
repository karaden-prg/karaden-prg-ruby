module Karaden
  module Net
    class Requestor < RequestorInterface
      DEFAULT_USER_AGENT = 'Karaden/Ruby/'.freeze

      def send(method, path, content_type = nil, params = nil, data = nil, request_options = nil, is_no_contents = false)
        request_options = Karaden::RequestOptions.new if request_options.nil?
        options = Karaden::Config.as_request_options.merge(request_options).validate
        headers = {
          'User-Agent': build_user_agent(options),
          'Karaden-Client-User-Agent': build_client_user_agent,
          'Karaden-Version' => options.api_version,
          'Content-Type': content_type,
          'Authorization': build_authorization(options),
        }

        uri = URI.parse(build_http_url(path, params, options))
        http = ::Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.open_timeout = options.connection_timeout
        http.read_timeout = options.read_timeout

        data = URI.encode_www_form(data) unless data.nil?
        response = http.send_request(method, uri.request_uri, data, headers)

        !is_no_contents ? Karaden::Net::Response.new(response, options) : Karaden::Net::NoContentsResponse.new(response, options)
      end

      protected

      def build_authorization(request_options)
        "Bearer #{request_options.api_key}"
      end

      def build_http_url(path, params, request_options)
        uri = URI(request_options.base_uri + path)
        uri.query = URI.encode_www_form(params) unless params.nil?
        uri.to_s
      end

      def build_user_agent(request_options)
        request_options.user_agent || DEFAULT_USER_AGENT + Karaden::Config::VERSION
      end

      def build_client_user_agent
        JSON.generate({
                        'bindings_version': Karaden::Config::VERSION,
                        'language': 'Ruby',
                        'language_version': Object::RUBY_VERSION,
                        'uname': Etc.uname.to_s
                      })
      end
    end
  end
end
