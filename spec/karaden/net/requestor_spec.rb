require 'webmock/rspec'

RSpec.describe Karaden::Net::Requestor do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  it 'ベースURLとパスが結合される' do
    path = '/test'
    request_options = Karaden::TestHelper.default_request_options_builder.build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |uri|
      expect(uri.to_s).to eq "#{Karaden::Config.as_request_options.merge(request_options).base_uri}#{path}"
    end).to_return(body: '', status: 200)

    requestor.send('GET', path, nil, nil, nil, request_options)
  end

  let(:method_provider) do
    %w[post get put delete option head]
  end

  it 'メソッドがHTTPクライアントに伝わる' do
    method_provider.each do |method|
      request_options = Karaden::TestHelper.default_request_options_builder.build
      requestor = Karaden::Net::Requestor.new
      stub_request(:any, lambda do |_uri|
        true
      end).to_return do |request|
        expect(request.method).to eq method.to_sym
        {}
      end

      requestor.send(method.to_s, '/test', nil, nil, nil, request_options)
    end
  end

  it 'URLパラメータがHTTPクライアントに伝わる' do
    params = { 'key1' => 'value1', 'key2' => 'value2' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |_uri|
      true
    end).to_return do |request|
      expect(request.uri.query).to eq URI.encode_www_form(params)
      {}
    end

    requestor.send('GET', '/test', nil, params, nil, request_options)
  end

  it '本文がHTTPクライアントに伝わる' do
    data = { 'key1' => 'value1', 'key2' => 'value2' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |_uri|
      true
    end).to_return do |request|
      expect(request.body).to eq URI.encode_www_form(data)
      {}
    end

    requestor.send('POST', '/test', nil, nil, data, request_options)
  end

  it 'APIキーに基づいてBearer認証ヘッダを出力する' do
    api_key = '456'
    request_options = Karaden::TestHelper.default_request_options_builder
    .with_api_key(api_key)
    .build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |_uri|
      true
    end).to_return do |request|
      expect(request.headers['Authorization']).to eq "Bearer #{api_key}"
      {}
    end

    requestor.send('GET', '/test', nil, nil, nil, request_options)
  end

  it 'APIバージョンを設定した場合はAPIバージョンヘッダを出力する' do
    api_version = '2023-01-01'
    request_options = Karaden::TestHelper.default_request_options_builder
    .with_api_version(api_version)
    .build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |_uri|
      true
    end).to_return do |request|
      expect(request.headers['Karaden-Version']).to eq api_version
      {}
    end

    requestor.send('GET', '/test', nil, nil, nil, request_options)
  end

  it 'APIバージョンを設定しない場合はデフォルトのAPIバージョンヘッダを出力する' do
    request_options = Karaden::TestHelper.default_request_options_builder
    .build
    requestor = Karaden::Net::Requestor.new
    stub_request(:any, lambda do |_uri|
      true
    end).to_return do |request|
      expect(request.headers['Karaden-Version']).to eq Karaden::Config::DEFALUT_API_VERSION
      {}
    end

    requestor.send('GET', '/test', nil, nil, nil, request_options)
  end
end
