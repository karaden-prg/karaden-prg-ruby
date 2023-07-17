RSpec.describe Karaden::RequestOptions do
  let(:api_base_provider) do
    [nil, '']
  end

  let(:api_key_provider) do
    [nil, '']
  end

  let(:api_version_provider) do
    [nil, '']
  end

  let(:tenant_id_provider) do
    [nil, '']
  end

  after(:each) do
    Karaden::Config.api_base = Karaden::TestHelper::API_BASE
    Karaden::Config.api_key = nil
    Karaden::Config.api_version = nil
    Karaden::Config.tenant_id = nil
    Karaden::Config.user_agent = nil
  end

  it 'baseUriはapi_baseとtenant_idを半角スラッシュで結合した値' do
    api_base = Karaden::TestHelper::API_BASE
    tenant_id = Karaden::TestHelper::TENANT_ID

    request_options = Karaden::RequestOptions.new_builder
    .with_api_base(api_base)
    .with_tenant_id(tenant_id)
    .build

    expect(request_options.base_uri).to eq "#{api_base}/#{tenant_id}"
  end

  it 'マージ元がnullならばマージ先を上書きしない' do
    api_key = Karaden::TestHelper::API_KEY
    request_options = [
      Karaden::RequestOptions.new_builder.with_api_key(api_key).build,
      Karaden::RequestOptions.new_builder.build
    ]
    merged = request_options[0].merge(request_options[1])
    expect(merged.api_key).to eq api_key
  end

  it 'マージ元がnullでなければマージ先を上書きする' do
    api_keys = %w[a b]
    request_options = [
      Karaden::RequestOptions.new_builder.with_api_key(api_keys[0]).build,
      Karaden::RequestOptions.new_builder.with_api_key(api_keys[1]).build
    ]
    merged = request_options[0].merge(request_options[1])
    expect(merged.api_key).to eq api_keys[1]
  end

  it 'api_baseがnullや空文字はエラー' do
    api_base_provider.each do |value|
      expect do
        Karaden::RequestOptions.new_builder
        .with_api_base(value)
        .build
        .validate
      end.to raise_error(Karaden::Exception::InvalidRequestOptionsException) { |e|
        messages = e.error.errors.property('api_version')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it 'api_keyがnullや空文字はエラー' do
    api_key_provider.each do |value|
      expect do
        Karaden::RequestOptions.new_builder
        .with_api_key(value)
        .build
        .validate
      end.to raise_error(Karaden::Exception::InvalidRequestOptionsException) { |e|
        messages = e.error.errors.property('api_key')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it 'api_versionがnullや空文字はエラー' do
    api_version_provider.each do |value|
      expect do
        Karaden::RequestOptions.new_builder
        .with_api_version(value)
        .build
        .validate
      end.to raise_error(Karaden::Exception::InvalidRequestOptionsException) { |e|
        messages = e.error.errors.property('api_version')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it 'tenant_idがnullや空文字はエラー' do
    tenant_id_provider.each do |value|
      expect do
        Karaden::RequestOptions.new_builder
        .with_tenant_id(value)
        .build
        .validate
      end.to raise_error(Karaden::Exception::InvalidRequestOptionsException) { |e|
        messages = e.error.errors.property('tenant_id')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end
end

RSpec.describe Karaden::RequestOptionsBuilder do
  it 'api_baseを入力できる' do
    expected = Karaden::TestHelper::API_BASE
    request_options = Karaden::RequestOptionsBuilder.new.with_api_base(expected).build
    expect(request_options.api_base).to eq expected
  end

  it 'api_keyを入力できる' do
    expected = Karaden::TestHelper::API_KEY
    request_options = Karaden::RequestOptionsBuilder.new.with_api_key(expected).build
    expect(request_options.api_key).to eq expected
  end

  it 'api_versionを入力できる' do
    expected = '2023-01-01'
    request_options = Karaden::RequestOptionsBuilder.new.with_api_version(expected).build
    expect(request_options.api_version).to eq expected
  end

  it 'tenant_idを入力できる' do
    expected = Karaden::TestHelper::TENANT_ID
    request_options = Karaden::RequestOptionsBuilder.new.with_tenant_id(expected).build
    expect(request_options.tenant_id).to eq expected
  end

  it 'user_agentを入力できる' do
    expected = 'userAgent'
    request_option = Karaden::RequestOptionsBuilder.new.with_user_agent(expected).build
    expect(request_option.user_agent).to eq expected
  end
end
