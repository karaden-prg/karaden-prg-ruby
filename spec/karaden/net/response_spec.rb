require 'webmock/rspec'

RSpec.describe Karaden::Net::Response do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  it '正常系のステータスコードで本文がJSONならばオブジェクトが返る' do
    stub_request(:any, lambda do |_|
      true
    end).to_return(body: '{}', status: 200)
    http = ::Net::HTTP.new('', '')
    http_response = http.send_request('GET', '/', '', {})

    request_options = Karaden::RequestOptions.new
    response = Karaden::Net::Response.new(http_response, request_options)

    expect(response.error?).to eq false
    expect(response.object.is_a?(Karaden::Model::KaradenObject)).to eq true
  end

  let(:code_provider) do
    [100, 200, 300, 400, 500]
  end

  it 'ステータスコードによらず本文がJSONでなければUnexpectedValueException' do
    code_provider.each do |code|
      stub_request(:any, lambda do |_|
        true
      end).to_return(body: '', status: code)
      http = ::Net::HTTP.new('', '')
      http_response = http.send_request('GET', '/', '', {})

      request_options = Karaden::RequestOptions.new
      response = Karaden::Net::Response.new(http_response, request_options)

      expect(response.error?).to eq true
      expect(response.error.is_a?(Karaden::Exception::UnexpectedValueException))
      expect(response.error.code).to eq code
    end
  end

  it 'エラー系のステータスコードで本文にobjectのプロパティがなければerror以外はUnexpectedValueException' do
    code = 400
    stub_request(:any, lambda do |_|
      true
    end).to_return(body: '{"test":"test"}', status: code)
    http = ::Net::HTTP.new('', '')
    http_response = http.send_request('GET', '/', '', {})

    request_options = Karaden::RequestOptions.new
    response = Karaden::Net::Response.new(http_response, request_options)

    expect(response.error?).to eq true
    expect(response.error.is_a?(Karaden::Exception::UnexpectedValueException))
    expect(response.error.code).to eq code
  end

  let(:object_provider) do
    ['message', '', nil]
  end

  it 'エラー系のステータスコードで本文にobjectのプロパティの値がerror以外はUnexpectedValueException' do
    object_provider.each do |object|
      code = 400
      stub_request(:any, lambda do |_|
        true
      end).to_return(body: "{\"object\":\"#{object}\"}", status: code)
      http = ::Net::HTTP.new('', '')
      http_response = http.send_request('GET', '/', '', {})

      request_options = Karaden::RequestOptions.new
      response = Karaden::Net::Response.new(http_response, request_options)

      expect(response.error?).to eq true
      expect(response.error.is_a?(Karaden::Exception::UnexpectedValueException))
      expect(response.error.code).to eq code
    end
  end

  let(:special_error_status_code_provider) do
    [
      Karaden::Exception::BadRequestException,
      Karaden::Exception::UnauthorizedException,
      Karaden::Exception::NotFoundException,
      Karaden::Exception::ForbiddenException,
      Karaden::Exception::UnprocessableEntityException,
      Karaden::Exception::TooManyRequestsException
    ]
  end

  let(:error_status_code_provider) do
    excluded = special_error_status_code_provider.map do |clazz|
      clazz::STATUS_CODE
    end
    ((100..199).to_a + (400..599).to_a).reject { |x| excluded.include?(x) }
  end

  it 'エラー系のステータスコードで特殊例外以外はUnknownErrorException' do
    error_status_code_provider.each do |code|
      stub_request(:any, lambda do |_|
        true
      end).to_return(body: '{"object": "error", "test": "test"}', status: code)
      http = ::Net::HTTP.new('', '')
      http_response = http.send_request('GET', '/', '', {})

      request_options = Karaden::RequestOptions.new
      response = Karaden::Net::Response.new(http_response, request_options)

      expect(response.error?).to eq true
      expect(response.error.is_a?(Karaden::Exception::UnknownErrorException))
      expect(response.error.code).to eq code
    end
  end

  it '特殊例外のステータスコード' do
    special_error_status_code_provider.each do |clazz|
      code = clazz::STATUS_CODE
      stub_request(:any, lambda do |_|
        true
      end).to_return(body: '{"object": "error", "test": "test"}', status: code)
      http = ::Net::HTTP.new('', '')
      http_response = http.send_request('GET', '/', '', {})

      request_options = Karaden::RequestOptions.new
      response = Karaden::Net::Response.new(http_response, request_options)

      expect(response.error?).to eq true
      expect(response.error.is_a?(clazz)).to eq true
    end
  end
end
