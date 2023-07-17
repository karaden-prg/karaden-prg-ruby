RSpec.describe Karaden::Param::Message::MessageCancelParams do
  let(:id_provider) do
    ['', nil]
  end

  it '正しいパスを生成できる' do
    id = 'id'
    params = Karaden::Param::Message::MessageCancelParams.new
    params.id = id
    expect(params.to_path).to eq "#{Karaden::Param::Message::MessageCancelParams::CONTEXT_PATH}/#{id}/cancel"
  end

  it 'idが空文字や未指定はエラー' do
    id_provider.each do |value|
      expect do
        params = Karaden::Param::Message::MessageCancelParams.new_builder
        .with_id(value)
        .build
        params.validate
      end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
        messages = e.error.errors.property('id')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end
end

RSpec.describe Karaden::Param::Message::MessageCancelParamsBuilder do
  it 'idを入力できる' do
    expected = 'id'
    params = Karaden::Param::Message::MessageCancelParamsBuilder.new
    .with_id(expected)
    .build
    expect(params.id).to eq expected
  end
end
