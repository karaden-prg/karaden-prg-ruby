require 'webmock/rspec'

RSpec.describe Karaden::Model::Message do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  it 'メッセージを作成できる' do
    object = { object: 'message' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::MessageCreateParams.new_builder
    .with_service_id(1)
    .with_to('to')
    .with_body('body')
    .with_tags(%w[a b])
    .build
    uri = "#{request_options.base_uri}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      expect(request.body).to eq 'service_id=1&to=to&body=body&tags%5B%5D=a&tags%5B%5D=b'
      expect(request.headers['Content-Type']).to eq 'application/x-www-form-urlencoded'
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.create(params, request_options)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージを作成できる(request_optionを渡さない)' do
    object = { object: 'message' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::MessageCreateParams.new_builder
    .with_service_id(1)
    .with_to('to')
    .with_body('body')
    .with_tags(%w[a b])
    .build
    uri = "#{request_options.base_uri}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      expect(request.body).to eq 'service_id=1&to=to&body=body&tags%5B%5D=a&tags%5B%5D=b'
      expect(request.headers['Content-Type']).to eq 'application/x-www-form-urlencoded'
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.create(params)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの詳細を取得できる' do
    object = { object: 'message' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::MessageDetailParams.new_builder
    .with_id('id')
    .build
    uri = "#{request_options.base_uri}/messages/#{params.id}"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.detail(params, request_options)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの詳細を取得できる(request_optionを渡さない)' do
    object = { object: 'message' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::MessageDetailParams.new_builder
    .with_id('id')
    .build
    uri = "#{request_options.base_uri}/messages/#{params.id}"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.detail(params)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの一覧を取得できる' do
    object = { object: 'list' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::MessageListParams.new_builder.build
    uri = "#{request_options.base_uri}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      request_uri = request.uri.clone
      request_uri.query = nil
      expect(request_uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.list(params, request_options)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの一覧を取得できる(request_optionを渡さない)' do
    object = { object: 'list' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::MessageListParams.new_builder.build
    uri = "#{request_options.base_uri}/messages"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :get
      request_uri = request.uri.clone
      request_uri.query = nil
      expect(request_uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.list(params)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの送信をキャンセルできる' do
    object = { object: 'message' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    params = Karaden::Param::Message::MessageCancelParams.new_builder
    .with_id('id')
    .build
    uri = "#{request_options.base_uri}/messages/#{params.id}/cancel"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.cancel(params, request_options)
    expect(message.object).to eq object[:object]
  end

  it 'メッセージの送信をキャンセルできる(request_optionを渡さない)' do
    object = { object: 'message' }
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = Karaden::TestHelper::API_KEY
    Karaden::Config.tenant_id = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::Config.as_request_options
    params = Karaden::Param::Message::MessageCancelParams.new_builder
    .with_id('id')
    .build
    uri = "#{request_options.base_uri}/messages/#{params.id}/cancel"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    message = Karaden::Model::Message.cancel(params)
    expect(message.object).to eq object[:object]
  end

  it 'service_idを出力できる' do
    value = 1
    message = Karaden::Model::Message.new
    message.set_property('service_id', value)
    expect(message.property('service_id')).to eq value
  end

  it 'billing_address_idを出力できる' do
    value = 1
    message = Karaden::Model::Message.new
    message.set_property('billing_address_id', value)
    expect(message.property('billing_address_id')).to eq value
  end

  it 'toを出力できる' do
    value = '1234567890'
    message = Karaden::Model::Message.new
    message.set_property('to', value)
    expect(message.property('to')).to eq value
  end

  it 'bodyを出力できる' do
    value = 'body'
    message = Karaden::Model::Message.new
    message.set_property('body', value)
    expect(message.property('body')).to eq value
  end

  it 'tagsを出力できる' do
    value = ['tag']
    message = Karaden::Model::Message.new
    message.set_property('tags', value)
    expect(message.property('tags')).to eq value
  end

  it 'statusを出力できる' do
    value = 'done'
    message = Karaden::Model::Message.new
    message.set_property('status', value)
    expect(message.property('status')).to eq value
  end

  it 'resultを出力できる' do
    value = 'none'
    message = Karaden::Model::Message.new
    message.set_property('result', value)
    expect(message.property('result')).to eq value
  end

  it 'sent_resultを出力できる' do
    value = 'none'
    message = Karaden::Model::Message.new
    message.set_property('sent_result', value)
    expect(message.property('sent_result')).to eq value
  end

  it 'carrierを出力できる' do
    value = 'docomo'
    message = Karaden::Model::Message.new
    message.set_property('carrier', value)
    expect(message.property('carrier')).to eq value
  end

  it 'scheduled_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('scheduled_at', value)
    expect(message.scheduled_at.iso8601).to eq value
  end

  it 'limited_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('limited_at', value)
    expect(message.limited_at.iso8601).to eq value
  end

  it 'sent_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('sent_at', value)
    expect(message.sent_at.iso8601).to eq value
  end

  it 'received_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('received_at', value)
    expect(message.received_at.iso8601).to eq value
  end

  it 'charged_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('charged_at', value)
    expect(message.charged_at.iso8601).to eq value
  end

  it 'created_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('created_at', value)
    expect(message.created_at.iso8601).to eq value
  end

  it 'updated_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    message = Karaden::Model::Message.new
    message.set_property('updated_at', value)
    expect(message.updated_at.iso8601).to eq value
  end
end
