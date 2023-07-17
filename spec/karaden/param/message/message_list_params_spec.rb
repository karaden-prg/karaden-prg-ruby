RSpec.describe Karaden::Param::Message::MessageCancelParams do
  it '正しいパスを生成できる' do
    params = Karaden::Param::Message::MessageListParams.new
    expect(params.to_path).to eq Karaden::Param::Message::MessageListParams::CONTEXT_PATH
  end

  it 'service_idをクエリにできる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParams.new
    params.service_id = expected
    actual = params.to_params
    expect(actual[:service_id]).to eq expected
  end

  it 'toをクエリにできる' do
    expected = 'to'
    params = Karaden::Param::Message::MessageListParams.new
    params.to = expected
    actual = params.to_params
    expect(actual[:to]).to eq expected
  end

  it 'statusをクエリにできる' do
    expected = 'status'
    params = Karaden::Param::Message::MessageListParams.new
    params.status = expected
    actual = params.to_params
    expect(actual[:status]).to eq expected
  end

  it 'resultをクエリにできる' do
    expected = 'result'
    params = Karaden::Param::Message::MessageListParams.new
    params.result = expected
    actual = params.to_params
    expect(actual[:result]).to eq expected
  end

  it 'sent_resultをクエリにできる' do
    expected = 'sent_result'
    params = Karaden::Param::Message::MessageListParams.new
    params.sent_result = expected
    actual = params.to_params
    expect(actual[:sent_result]).to eq expected
  end

  it 'tagをクエリにできる' do
    expected = 'tag'
    params = Karaden::Param::Message::MessageListParams.new
    params.tag = expected
    actual = params.to_params
    expect(actual[:tag]).to eq expected
  end

  it 'start_atをクエリにできる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageListParams.new
    params.start_at = expected
    actual = params.to_params
    expect(actual[:start_at]).to eq expected.iso8601
  end

  it 'end_atをクエリにできる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageListParams.new
    params.end_at = expected
    actual = params.to_params
    expect(actual[:end_at]).to eq expected.iso8601
  end

  it 'pageをクエリにできる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParams.new
    params.page = expected
    actual = params.to_params
    expect(actual[:page]).to eq expected
  end

  it 'per_pageをクエリにできる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParams.new
    params.per_page = expected
    actual = params.to_params
    expect(actual[:per_page]).to eq expected
  end
end

RSpec.describe Karaden::Param::Message::MessageListParamsBuilder do
  it 'service_idを入力できる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_service_id(expected)
    .build
    expect(params.service_id).to eq expected
  end

  it 'toを入力できる' do
    expected = 'to'
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_to(expected)
    .build
    expect(params.to).to eq expected
  end

  it 'statusを入力できる' do
    expected = 'status'
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_status(expected)
    .build
    expect(params.status).to eq expected
  end

  it 'resultを入力できる' do
    expected = 'result'
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_result(expected)
    .build
    expect(params.result).to eq expected
  end

  it 'sent_resultを入力できる' do
    expected = 'sent_result'
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_sent_result(expected)
    .build
    expect(params.sent_result).to eq expected
  end

  it 'tagを入力できる' do
    expected = 'tag'
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_tag(expected)
    .build
    expect(params.tag).to eq expected
  end

  it 'start_atを入力できる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_start_at(expected)
    .build
    expect(params.start_at).to eq expected
  end

  it 'end_atを入力できる' do
    expected = Time.parse('2022-12-10T00:00:00+09:00')
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_end_at(expected)
    .build
    expect(params.end_at).to eq expected
  end

  it 'pageを入力できる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_page(expected)
    .build
    expect(params.page).to eq expected
  end

  it 'per_pageを入力できる' do
    expected = 1
    params = Karaden::Param::Message::MessageListParamsBuilder.new
    .with_per_page(expected)
    .build
    expect(params.per_page).to eq expected
  end
end
