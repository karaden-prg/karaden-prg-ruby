# frozen_string_literal: true

require 'karaden'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module Karaden
  class TestHelper
    API_BASE = 'http://localhost:4010'
    API_KEY = '123'
    API_VERSION = '2023-12-01'
    TENANT_ID = '159bfd33-b9b7-f424-4755-c119b324591d'

    def self.default_request_options_builder
      RequestOptions.new_builder
      .with_api_base(API_BASE)
      .with_api_key(API_KEY)
      .with_api_version(API_VERSION)
      .with_tenant_id(TENANT_ID)
    end
  end
end
