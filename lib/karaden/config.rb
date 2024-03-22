module Karaden
  class Config
    VERSION = '1.2.0'.freeze
    DEFAULT_API_BASE = 'https://prg.karaden.jp/api'.freeze
    DEFALUT_API_VERSION = '2024-03-01'.freeze

    @@http_client = nil
    @@logger = nil
    @@formatter = nil
    @@api_version = DEFALUT_API_VERSION
    @@api_key = nil
    @@tenant_id = nil
    @@user_agent = nil
    @@api_base = DEFAULT_API_BASE

    def self.api_base
      @@api_base
    end

    def self.api_base=(val)
      @@api_base = val
    end

    def self.api_key
      @@api_key
    end

    def self.api_key=(val)
      @@api_key = val
    end

    def self.api_version
      @@api_version
    end

    def self.api_version=(val)
      @@api_version = val
    end

    def self.tenant_id
      @@tenant_id
    end

    def self.tenant_id=(val)
      @@tenant_id = val
    end

    def self.user_agent
      @@user_agent
    end

    def self.user_agent=(val)
      @@user_agent = val
    end

    def self.reset
      @@api_base = DEFAULT_API_BASE
      @@api_key = nil
      @@api_version = DEFALUT_API_VERSION
      @@tenant_id = nil
      @@user_agent = nil
      @@http_client = nil
      @@logger = nil
      @@formatter = nil
    end

    def self.as_request_options
      RequestOptions
      .new_builder
      .with_api_version(@@api_version)
      .with_api_key(@@api_key)
      .with_tenant_id(@@tenant_id)
      .with_user_agent(@@user_agent)
      .with_api_base(@@api_base)
      .build
    end
  end
end
