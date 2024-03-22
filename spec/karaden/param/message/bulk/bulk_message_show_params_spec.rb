require 'webmock/rspec'

RSpec.describe Karaden::Param::Message::Bulk::BulkMessageShowParams do
  it '正しいパスを生成できる' do
    id = '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    params = Karaden::Param::Message::Bulk::BulkMessageShowParams.new
    params.id = id
    expect(params.to_path).to eq "#{Karaden::Param::Message::Bulk::BulkMessageShowParams::CONTEXT_PATH}/#{id}"
  end

  it 'idは必須のバリデーションをする' do
    params = Karaden::Param::Message::Bulk::BulkMessageShowParams.new
    expect do
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('id')
      expect(messages.is_a?(Array)).to eq true
    }
  end
end

RSpec.describe Karaden::Param::Message::Bulk::BulkMessageShowParamsBuilder do
  it 'idを入力できる' do
    expected = '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    params = Karaden::Param::Message::Bulk::BulkMessageShowParamsBuilder.new
      .with_id(expected)
      .build
    expect(params.id).to eq expected
  end
end
