RSpec.describe Karaden::Config do
  it '入力したapi_baseが取得したRequestOptionsに入力されること' do
    expected = Karaden::TestHelper::API_BASE
    Karaden::Config.api_base = expected
    request_options = Karaden::Config.as_request_options
    expect(request_options.api_base).to eq expected
  end

  it '入力したapi_keyが取得したRequestOptionsに入力されること' do
    expected = Karaden::TestHelper::API_KEY
    Karaden::Config.api_key = expected
    request_options = Karaden::Config.as_request_options
    expect(request_options.api_key).to eq expected
  end

  it '入力したapi_versionが取得したRequestOptionsに入力されること' do
    expected = '2023-01-01'
    Karaden::Config.api_version = expected
    request_options = Karaden::Config.as_request_options
    expect(request_options.api_version).to eq expected
  end

  it '入力したtenant_idが取得したRequestOptionsに入力されること' do
    expected = Karaden::TestHelper::TENANT_ID
    Karaden::Config.tenant_id = expected
    request_options = Karaden::Config.as_request_options
    expect(request_options.tenant_id).to eq expected
  end

  it '入力したuser_agentが取得したRequestOptionsに入力されること' do
    expected = 'userAgent'
    Karaden::Config.user_agent = expected
    request_options = Karaden::Config.as_request_options
    expect(request_options.user_agent).to eq expected
  end
end
