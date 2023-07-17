RSpec.describe Karaden::Model::Collection do
  it 'dataを出力できる' do
    collection = Karaden::Model::Collection.new
    collection.set_property('data', [])
    expect(collection.data.is_a?(Array)).to eq true
  end

  it 'more?を出力できる' do
    collection = Karaden::Model::Collection.new
    collection.set_property('has_more', true)
    expect(collection.more?).to eq true
  end
end
