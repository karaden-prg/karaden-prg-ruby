RSpec.describe Karaden::Model::Error do
  it 'codeを出力できる' do
    code = 'code'
    error = Karaden::Model::Error.new
    error.set_property('code', code)
    expect(error.code).to eq code
  end

  it 'messageを出力できる' do
    message = 'message'
    error = Karaden::Model::Error.new
    error.set_property('message', message)
    expect(error.message).to eq message
  end

  it 'errorsを出力できる' do
    value = Karaden::Model::KaradenObject.new
    error = Karaden::Model::Error.new
    error.set_property('errors', value)
    expect(error.errors.is_a?(Karaden::Model::KaradenObject)).to eq true
  end
end
