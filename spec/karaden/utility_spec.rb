require 'tempfile'
require 'webmock/rspec'

RSpec.describe Karaden::Utility do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  let(:primitive_value_provider) do
    ['string', '', 123, 0, true, false, nil]
  end

  let(:object_item_provider) do
    [
      [{}, Karaden::Model::KaradenObject],
      [{ 'object' => nil }, Karaden::Model::KaradenObject],
      [{ 'object' => 'test' }, Karaden::Model::KaradenObject],
      [{ 'object' => 'message' }, Karaden::Model::Message]
    ]
  end

  it 'objectのフィールドが存在しない場合はKaradenObjectが返る' do
    contents = JSON.parse('{"test": "test"}')
    object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
    expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
  end

  it 'objectのフィールドが存在してObjectTypesのマッピングが存在する場合はオブジェクトが返る' do
    contents = JSON.parse('{"object": "message"}')
    object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
    expect(object.is_a?(Karaden::Model::Message)).to eq true
  end

  it 'objectのフィールドが存在してObjectTypesのマッピングに存在しない場合はKaradenObjectが返る' do
    contents = JSON.parse('{"object": "test"}')
    object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
    expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
  end

  it 'プリミティブな値はデシリアライズしても変わらない' do
    primitive_value_provider.each do |value|
      key = 'test'
      contents = JSON.parse(JSON.generate({ key => value }))
      object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
      expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
      expect(object.property(key)).to eq value
    end
  end

  it 'プリミティブな値の配列の要素はデシリアライズしても変わらない' do
    primitive_value_provider.each do |value|
      contents = JSON.parse(JSON.generate({ 'test' => [value] }))
      object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
      expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
      expect(object.property('test').is_a?(Array)).to eq true
      expect(object.property('test')[0]).to eq value
    end
  end

  it '配列の配列もサポートする' do
    value = 'test'
    contents = JSON.parse("{\"test\": [[\"#{value}\"]]}")
    object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
    expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
    expect(object.property('test').is_a?(Array)).to eq true
    expect(object.property('test').count).to eq 1
    expect(object.property('test')[0].is_a?(Array)).to eq true
    expect(object.property('test')[0][0]).to eq value
  end

  it 'オブジェクトの配列の要素はデシリアライズするとKaradenObjectに変換される' do
    object_item_provider.each do |item, clazz|
      item['test'] = 'test'
      contents = JSON.parse(JSON.generate({ 'test' => [item] }))
      object = Karaden::Utility.convert_to_karaden_object(contents, Karaden::RequestOptions.new)
      expect(object.is_a?(Karaden::Model::KaradenObject)).to eq true
      expect(object.property('test').is_a?(Array)).to eq true
      expect(object.property('test')[0].is_a?(clazz)).to eq true
      expect(object.property('test')[0].property('test')).to eq item['test']
    end
  end

  it '指定のURLにfileパスのファイルをPUTメソッドでリクエストする' do
    file = Tempfile.new
    filename = file.path
    file.close

    signed_url = 'https://example.com/'

    stub_request(:any, signed_url).to_return do |request|
      expect(request.method).to eq :put
      expect(request.uri.omit(:port).to_s).to eq signed_url
      { status: 200 }
    end

    Karaden::Utility.put_signed_url(signed_url, filename)
  end

  it 'レスポンスコードが200以外だとFileUploadFailedExceptionが返る' do
    file = Tempfile.new
    filename = file.path
    file.close
    signed_url = 'https://example.com/'

    stub_request(:any, signed_url).to_return do |request|
      expect(request.method).to eq :put
      expect(request.uri.omit(:port).to_s).to eq signed_url
      { status: 403 }
    end

    expect do
      Karaden::Utility.put_signed_url(signed_url, filename)
    end.to raise_error(Karaden::Exception::FileUploadFailedException)
  end

  it '例外が発生するとFileUploadFailedExceptionをリスローする' do
    file = Tempfile.new
    filename = file.path
    file.close
    signed_url = 'https://example.com/'

    stub_request(:any, signed_url).to_return do
      raise StandardError
    end

    expect do
      Karaden::Utility.put_signed_url(signed_url, filename)
    end.to raise_error(Karaden::Exception::FileUploadFailedException)
  end

  it 'Content-Typeを指定できる' do
    file = Tempfile.new
    filename = file.path
    file.close

    signed_url = 'https://example.com/'
    content_type = 'text/csv'

    stub_request(:any, signed_url).to_return do |request|
      expect(request.method).to eq :put
      expect(request.uri.omit(:port).to_s).to eq signed_url
      expect(request.headers['Content-Type']).to eq content_type
      { status: 200 }
    end

    Karaden::Utility.put_signed_url(signed_url, filename, content_type)
  end
end
