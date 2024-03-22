require 'webmock/rspec'

RSpec.describe Karaden::Model::BulkMessage do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  let(:location_provider) do
    ['location', 'LOCATION']
  end

  it '一括送信メッセージを作成できる' do
    object = { object: 'bulk_message' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParams.new_builder
      .with_bulk_file_id('c439f89c-1ea3-7073-7021-1f127a850437')
      .build
    uri = "#{request_options.base_uri}/messages/bulks"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      expect(request.body).to eq 'bulk_file_id=c439f89c-1ea3-7073-7021-1f127a850437'
      expect(request.headers['Content-Type']).to eq 'application/x-www-form-urlencoded'
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    bulk_message = Karaden::Model::BulkMessage.create(params, request_options)
    expect(bulk_message.object).to eq object[:object]
  end

  it '一括送信メッセージを作成できる(request_optionを渡さない)' do
    object = { object: 'bulk_message' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParams.new_builder
      .with_bulk_file_id('c439f89c-1ea3-7073-7021-1f127a850437')
      .build
    uri = "#{request_options.base_uri}/messages/bulks"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      expect(request.body).to eq 'bulk_file_id=c439f89c-1ea3-7073-7021-1f127a850437'
      expect(request.headers['Content-Type']).to eq 'application/x-www-form-urlencoded'
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    bulk_message = Karaden::Model::BulkMessage.create(params, request_options)
    expect(bulk_message.object).to eq object[:object]
  end

  it '一括送信メッセージの詳細を取得できる' do
    object = { object: 'bulk_message' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::Bulk::BulkMessageShowParams.new_builder
      .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
      .build
    uri = "#{request_options.base_uri}/messages/bulks/#{params.id}"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    bulk_message = Karaden::Model::BulkMessage.show(params, request_options)
    expect(bulk_message.object).to eq object[:object]
  end

  it '一括送信メッセージの詳細を取得できる(request_optionを渡さない)' do
    object = { object: 'bulk_message' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::Bulk::BulkMessageShowParams.new_builder
      .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
      .build
    uri = "#{request_options.base_uri}/messages/bulks/#{params.id}"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    bulk_message = Karaden::Model::BulkMessage.show(params, request_options)
    expect(bulk_message.object).to eq object[:object]
  end

  it '一括送信メッセージの結果を取得できる' do
    expect_url = 'http://example.com'
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::Bulk::BulkMessageListMessageParams.new_builder
      .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
      .build
    uri = "#{request_options.base_uri}/messages/bulks/#{params.id}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 302, body: nil, headers: { 'Location' => expect_url } }
    end

    output = Karaden::Model::BulkMessage.list_message(params, request_options)
    expect(output).to eq expect_url
  end

  it '一括送信メッセージの結果を取得できる(request_optionを渡さない)' do
    expect_url = 'http://example.com'
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::Bulk::BulkMessageListMessageParams.new_builder
      .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
      .build
    uri = "#{request_options.base_uri}/messages/bulks/#{params.id}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 302, body: nil, headers: { 'Location' => expect_url } }
    end

    output = Karaden::Model::BulkMessage.list_message(params, request_options)
    expect(output).to eq expect_url
  end

  it 'Locationが大文字小文字関係なく一括送信メッセージの結果を取得できる' do
    location_provider.each do |location|
      expect_url = 'http://example.com'
      request_options = Karaden::TestHelper.default_request_options_builder.build
      params = Karaden::Param::Message::Bulk::BulkMessageListMessageParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .build
      uri = "#{request_options.base_uri}/messages/bulks/#{params.id}/messages"
      stub_request(:any, lambda do |_|
        true
      end).to_return do |request|
        expect(request.method).to eq :get
        expect(request.uri.to_s).to eq uri
        { status: 302, body: nil, headers: { location => expect_url } }
      end

      output = Karaden::Model::BulkMessage.list_message(params, request_options)
      expect(output).to eq expect_url
    end
  end

  it 'Locationが大文字小文字関係なく一括送信メッセージの結果を取得できる(request_optionを渡さない)' do
    location_provider.each do |location|
      expect_url = 'http://example.com'
      Karaden::Config.api_base = Karaden::TestHelper::API_BASE
      Karaden::Config.api_key = Karaden::TestHelper::API_KEY
      Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
      request_options = Karaden::Config.as_request_options
      params = Karaden::Param::Message::Bulk::BulkMessageListMessageParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .build
      uri = "#{request_options.base_uri}/messages/bulks/#{params.id}/messages"
      stub_request(:any, lambda do |_|
        true
      end).to_return do |request|
        expect(request.method).to eq :get
        expect(request.uri.to_s).to eq uri
        { status: 302, body: nil, headers: { location => expect_url } }
      end

      output = Karaden::Model::BulkMessage.list_message(params, request_options)
      expect(output).to eq expect_url
    end
  end

  it 'statusを出力できる' do
    value = 'processing'
    bulk_message = Karaden::Model::BulkMessage.new
    bulk_message.set_property('status', value)
    expect(bulk_message.property('status')).to eq value
  end

  it '受付エラーがない場合はerrorは出力されない' do
    error = nil
    bulk_message = Karaden::Model::BulkMessage.new
    bulk_message.set_property('error', error)
    expect(bulk_message.property('error')).to be nil
  end

  it '受付エラーがあった場合はerrorが出力される' do
    error = Karaden::Model::Error.new
    bulk_message = Karaden::Model::BulkMessage.new
    bulk_message.set_property('error', error)
    expect(bulk_message.property('error')).to be_an error.class
  end

  it 'created_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    bulk_message = Karaden::Model::BulkMessage.new
    bulk_message.set_property('created_at', value)
    expect(bulk_message.created_at.iso8601).to eq value
  end

  it 'updated_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    bulk_message = Karaden::Model::BulkMessage.new
    bulk_message.set_property('updated_at', value)
    expect(bulk_message.updated_at.iso8601).to eq value
  end
end
