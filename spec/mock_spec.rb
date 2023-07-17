RSpec.describe 'Mock' do
  it '作成（送信）' do
    datetime = Time.parse('2020-01-31T23:59:59+09:00')
    params = Karaden::Param::Message::MessageCreateParams.new_builder
    .with_service_id(1)
    .with_to('09012345678')
    .with_body('本文')
    .with_is_shorten(true)
    .with_limited_at(datetime)
    .with_scheduled_at(datetime)
    .with_tags(%w[タグ1 タグ2 タグ３])
    .build

    request_options = Karaden::TestHelper.default_request_options_builder.build
    message = Karaden::Model::Message.create(params, request_options)
    expect(message.id).to eq '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    expect(message.object).to eq 'message'
    expect(message.service_id).to eq 1
    expect(message.billing_address_id).to eq 1
    expect(message.to).to eq '09012345678'
    expect(message.body).to eq '本文'
    tags = message.tags
    expect(tags.is_a?(Array)).to eq true
    expect(tags.count).to eq 1
    expect(tags[0]).to eq 'string'
    expect(message.shorten?).to eq true
    expect(message.result).to eq 'done'
    expect(message.status).to eq 'done'
    expect(message.sent_result).to eq 'none'
    expect(message.carrier).to eq 'docomo'
    expect(message.scheduled_at).to eq datetime
    expect(message.limited_at).to eq datetime
    expect(message.sent_at).to eq datetime
    expect(message.scheduled_at).to eq datetime
    expect(message.received_at).to eq datetime
    expect(message.created_at).to eq datetime
    expect(message.updated_at).to eq datetime
  end

  it '一覧' do
    datetime = Time.parse('2020-01-31T23:59:59+09:00')
    params = Karaden::Param::Message::MessageListParams.new_builder
    .with_service_id(1)
    .with_to('09012345678')
    .with_status('done')
    .with_result('done')
    .with_sent_result('none')
    .with_tag('string')
    .with_start_at(datetime)
    .with_end_at(datetime)
    .with_page(0)
    .with_per_page(100)
    .build

    request_options = Karaden::TestHelper.default_request_options_builder.build
    collection = Karaden::Model::Message.list(params, request_options)

    expect('list').to eq collection.object
    expect(true).to eq collection.more?
    messages = collection.data
    expect(1).to eq messages.count
    message = messages[0]
    expect(message.id).to eq '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    expect(message.object).to eq 'message'
    expect(message.service_id).to eq 1
    expect(message.billing_address_id).to eq 1
    expect(message.to).to eq '09012345678'
    expect(message.body).to eq '本文'
    tags = message.tags
    expect(tags.is_a?(Array)).to eq true
    expect(tags.count).to eq 1
    expect(tags[0]).to eq 'string'
    expect(message.shorten?).to eq true
    expect(message.result).to eq 'done'
    expect(message.status).to eq 'done'
    expect(message.sent_result).to eq 'none'
    expect(message.carrier).to eq 'docomo'
    expect(message.scheduled_at).to eq datetime
    expect(message.limited_at).to eq datetime
    expect(message.sent_at).to eq datetime
    expect(message.scheduled_at).to eq datetime
    expect(message.received_at).to eq datetime
    expect(message.created_at).to eq datetime
    expect(message.updated_at).to eq datetime
  end

  it '詳細' do
    datetime = Time.parse('2020-01-31T23:59:59+09:00')
    params = Karaden::Param::Message::MessageDetailParams.new_builder
    .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
    .build

    request_options = Karaden::TestHelper.default_request_options_builder.build
    message = Karaden::Model::Message.detail(params, request_options)
    expect(message.id).to eq '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    expect(message.object).to eq 'message'
    expect(message.service_id).to eq 1
    expect(message.billing_address_id).to eq 1
    expect(message.to).to eq '09012345678'
    expect(message.body).to eq '本文'
    tags = message.tags
    expect(tags.is_a?(Array)).to eq true
    expect(tags.count).to eq 1
    expect(tags[0]).to eq 'string'
    expect(message.shorten?).to eq true
    expect(message.result).to eq 'done'
    expect(message.status).to eq 'done'
    expect(message.sent_result).to eq 'none'
    expect(message.carrier).to eq 'docomo'
    expect(message.scheduled_at).to eq datetime
    expect(message.limited_at).to eq datetime
    expect(message.sent_at).to eq datetime
    expect(message.scheduled_at).to eq datetime
    expect(message.received_at).to eq datetime
    expect(message.created_at).to eq datetime
    expect(message.updated_at).to eq datetime
  end

  it 'キャンセル' do
    datetime = Time.parse('2020-01-31T23:59:59+09:00')
    params = Karaden::Param::Message::MessageCancelParams.new_builder
    .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
    .build

    request_options = Karaden::TestHelper.default_request_options_builder.build
    message = Karaden::Model::Message.cancel(params, request_options)
    expect(message.id).to eq '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    expect(message.object).to eq 'message'
    expect(message.service_id).to eq 1
    expect(message.billing_address_id).to eq 1
    expect(message.to).to eq '09012345678'
    expect(message.body).to eq '本文'
    tags = message.tags
    expect(tags.is_a?(Array)).to eq true
    expect(tags.count).to eq 1
    expect(tags[0]).to eq 'string'
    expect(message.shorten?).to eq true
    expect(message.result).to eq 'done'
    expect(message.status).to eq 'done'
    expect(message.sent_result).to eq 'none'
    expect(message.carrier).to eq 'docomo'
    expect(message.scheduled_at).to eq datetime
    expect(message.limited_at).to eq datetime
    expect(message.sent_at).to eq datetime
    expect(message.scheduled_at).to eq datetime
    expect(message.received_at).to eq datetime
    expect(message.created_at).to eq datetime
    expect(message.updated_at).to eq datetime
  end
end
