module Karaden
  class RequestOptions
    attr_accessor :api_base, :api_key, :api_version, :tenant_id, :user_agent, :connection_timeout, :read_timeout

    def initialize
      @api_base = nil
      @api_key = nil
      @api_version = nil
      @tenant_id = nil
      @user_agent = nil
      @connection_timeout = nil
      @read_timeout = nil
    end

    def base_uri
      "#{@api_base}/#{@tenant_id}"
    end

    def merge(source)
      clone.tap do |obj|
        %i[api_base api_key api_version tenant_id user_agent].each do |prop|
          val = source.send(prop)
          obj.send("#{prop}=", val) unless val.nil?
        end
      end
    end

    def validate
      errors = Karaden::Model::KaradenObject.new
      has_error = false

      messages = validate_api_base
      unless messages.empty?
        errors.set_property('api_base', messages)
        has_error = true
      end

      messages = validate_api_key
      unless messages.empty?
        errors.set_property('api_key', messages)
        has_error = true
      end

      messages = validate_api_version
      unless messages.empty?
        errors.set_property('api_version', messages)
        has_error = true
      end

      messages = validate_tenant_id
      unless messages.empty?
        errors.set_property('tenant_id', messages)
        has_error = true
      end

      if has_error
        e = Karaden::Exception::InvalidRequestOptionsException.new
        error = Karaden::Model::Error.new
        error.set_property('object', Karaden::Model::Error::OBJECT_NAME)
        error.set_property('errors', errors)
        e.error = error
        raise e
      end

      self
    end

    def self.new_builder
      RequestOptionsBuilder.new
    end

    protected

    def validate_api_base
      messages = []
      if @api_base.nil? || @api_base == ''
        messages << 'api_baseは必須です。'
        messages << '文字列を入力してください。'
      end
      messages
    end

    def validate_api_key
      messages = []
      if @api_key.nil? || @api_key == ''
        messages << 'api_keyは必須です。'
        messages << '文字列を入力してください。'
      end
      messages
    end

    def validate_api_version
      messages = []
      if @api_version.nil? || @api_version == ''
        messages << 'api_versionは必須です。'
        messages << '文字列を入力してください。'
      end
      messages
    end

    def validate_tenant_id
      messages = []
      if @tenant_id.nil? || @tenant_id == ''
        messages << 'tenant_idは必須です。'
        messages << '文字列を入力してください。'
      end
      messages
    end
  end

  class RequestOptionsBuilder
    def initialize
      @request_options = RequestOptions.new
    end

    def with_api_base(api_base)
      @request_options.api_base = api_base
      self
    end

    def with_api_key(api_key)
      @request_options.api_key = api_key
      self
    end

    def with_api_version(api_version)
      @request_options.api_version = api_version
      self
    end

    def with_tenant_id(tenant_id)
      @request_options.tenant_id = tenant_id
      self
    end

    def with_user_agent(user_agent)
      @request_options.user_agent = user_agent
      self
    end

    def with_connection_timeout(connection_timeout)
      @request_options.connection_timeout = connection_timeout
      self
    end

    def with_read_timeout(read_timeout)
      @request_options.read_timeout = read_timeout
      self
    end

    def build
      @request_options.clone
    end
  end
end
