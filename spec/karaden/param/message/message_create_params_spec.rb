RSpec.describe Karaden::Param::Message::MessageCreateParams do
  let(:is_shorten_provider) do
    [
      [true, 'true'],
      [false, 'false'],
      [nil, nil]
    ]
  end

  it '正しいパスを生成できる' do
    params = Karaden::Param::Message::MessageCreateParams.new
    expect(params.to_path).to eq Karaden::Param::Message::MessageCreateParams::CONTEXT_PATH
  end

  it 'service_idを送信データにできる' do
    expected = 1
    params = Karaden::Param::Message::MessageCreateParams.new
    params.service_id = expected
    actual = params.to_data
    expect(actual[:service_id]).to eq expected
  end

  it 'service_idは必須のバリデーションをする' do
    params = Karaden::Param::Message::MessageCreateParams.new
    expect do
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('service_id')
      expect(messages.is_a?(Array)).to eq true
    }
  end

  it 'toを送信データにできる' do
    expected = 'to'
    params = Karaden::Param::Message::MessageCreateParams.new
    params.to = expected
    actual = params.to_data
    expect(actual[:to]).to eq expected
  end

  it 'toは必須のバリデーションをする' do
    params = Karaden::Param::Message::MessageCreateParams.new
    expect do
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('to')
      expect(messages.is_a?(Array)).to eq true
    }
  end

  it 'bodyを送信データにできる' do
    expected = 'body'
    params = Karaden::Param::Message::MessageCreateParams.new
    params.body = expected
    actual = params.to_data
    expect(actual[:body]).to eq expected
  end

  it 'bodyは必須のバリデーションをする' do
    params = Karaden::Param::Message::MessageCreateParams.new
    expect do
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('body')
      expect(messages.is_a?(Array)).to eq true
    }
  end

  it 'tagsを送信データにできる' do
    expected = ['tag']
    params = Karaden::Param::Message::MessageCreateParams.new
    params.tags = expected
    actual = params.to_data
    expect(actual['tags[]']).to eq expected
  end

  it 'is_shortenを送信データにできる' do
    is_shorten_provider.each do |param, expected|
      params = Karaden::Param::Message::MessageCreateParams.new
      params.is_shorten = param
      actual = params.to_data
      expect(actual[:is_shorten]).to eq expected
    end
  end

  it 'scheduled_atを送信データにできる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageCreateParams.new
    params.scheduled_at = expected
    actual = params.to_data
    expect(actual[:scheduled_at]).to eq expected.iso8601
  end

  it 'limited_atを送信データにできる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageCreateParams.new
    params.limited_at = expected
    actual = params.to_data
    expect(actual[:limited_at]).to eq expected.iso8601
  end
end

RSpec.describe Karaden::Param::Message::MessageCreateParamsBuilder do
  it 'service_idを入力できる' do
    expected = 1
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_service_id(expected)
    .build
    expect(params.service_id).to eq expected
  end

  it 'toを入力できる' do
    expected = 'to'
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_to(expected)
    .build
    expect(params.to).to eq expected
  end

  it 'bodyを入力できる' do
    expected = 'body'
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_body(expected)
    .build
    expect(params.body).to eq expected
  end

  it 'tagsを入力できる' do
    expected = ['tag']
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_tags(expected)
    .build
    expect(JSON.generate(params.tags)).to eq JSON.generate(expected)
  end

  it 'is_shortenを入力できる' do
    expected = true
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_is_shorten(expected)
    .build
    expect(params.is_shorten).to eq expected
  end

  it 'scheduled_atを入力できる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_scheduled_at(expected)
    .build
    expect(params.scheduled_at).to eq expected
  end

  it 'limited_atを入力できる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageCreateParamsBuilder.new
    .with_limited_at(expected)
    .build
    expect(params.limited_at).to eq expected
  end
end
