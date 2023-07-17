RSpec.describe Karaden::Model::KaradenObject do
  let(:primitive_value_provider) do
    ['string', '', 123, 0, true, false, nil]
  end

  let(:id_value_provider) do
    ['string', '', 123, 0, true, false, nil]
  end

  it 'プロパティに入出力できる' do
    key = 'test'
    primitive_value_provider.each do |value|
      object = Karaden::Model::KaradenObject.new
      object.set_property(key, value)
      expect(object.property(key)).to eq value
    end
  end

  it 'プロパティのキーを列挙できる' do
    expected = %w[key1 key2]
    object = Karaden::Model::KaradenObject.new
    expected.each do |key|
      object.set_property(key, key)
    end
    keys = object.property_keys
    expect(keys.is_a?(Array)).to eq true
    expected.each do |key|
      expect(keys.include?(key)).to eq true
    end
  end

  it 'idを出力できる' do
    id_value_provider.each do |value|
      object = Karaden::Model::KaradenObject.new
      object.set_property('id', value)
      expect(object.id).to eq value
    end
  end

  it 'objectを出力できる' do
    expected = 'test'
    object = Karaden::Model::KaradenObject.new
    object.set_property('object', expected)
    expect(object.object).to eq expected
  end
end
