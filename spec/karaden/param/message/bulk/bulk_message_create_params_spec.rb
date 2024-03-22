require 'webmock/rspec'

RSpec.describe Karaden::Param::Message::MessageCreateParams do
  it '正しいパスを生成できる' do
    bulk_file_id = 'c439f89c-1ea3-7073-7021-1f127a850437'
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParams.new
    params.bulk_file_id = bulk_file_id
    expect(params.to_path).to eq Karaden::Param::Message::Bulk::BulkMessageCreateParams::CONTEXT_PATH
  end

  it 'bulk_file_idを送信データにできる' do
    expected = 'c439f89c-1ea3-7073-7021-1f127a850437'
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParams.new
    params.bulk_file_id = expected
    actual = params.to_data
    expect(actual[:bulk_file_id]).to eq expected
  end

  it 'bulk_file_idは必須のバリデーションをする' do
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParams.new
    expect do
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('bulk_file_id')
      expect(messages.is_a?(Array)).to eq true
    }
  end
end

RSpec.describe Karaden::Param::Message::Bulk::BulkMessageCreateParamsBuilder do
  it 'bulk_file_idを入力できる' do
    expected = 'c439f89c-1ea3-7073-7021-1f127a850437'
    params = Karaden::Param::Message::Bulk::BulkMessageCreateParamsBuilder.new
      .with_bulk_file_id(expected)
      .build
    expect(params.bulk_file_id).to eq expected
  end
end
