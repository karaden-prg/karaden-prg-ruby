require 'webmock/rspec'

RSpec.describe Karaden::Model::BulkFile do
  before do
    WebMock.enable!
  end
  after do
    WebMock.disable!
  end

  it '一括送信用CSVのアップロード先URLを発行できる' do
    object = { object: 'bulk_file' }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    uri = "#{request_options.base_uri}/messages/bulks/files"
    stub_request(:any, lambda do |_|
      true
    end).to_return do |request|
      expect(request.method).to eq :post
      expect(request.uri.to_s).to eq uri
      { status: 200, body: JSON.generate(object), headers: { 'Content-Type' => 'application/json' } }
    end

    bulk_file = Karaden::Model::BulkFile.create(request_options)
    expect(bulk_file.object).to eq object[:object]
  end

  it 'urlを出力できる' do
    value = 'https://example.com/'
    bulk_file = Karaden::Model::BulkFile.new
    bulk_file.set_property('url', value)
    expect(bulk_file.property('url')).to eq value
  end

  it 'created_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    bulk_file = Karaden::Model::BulkFile.new
    bulk_file.set_property('created_at', value)
    expect(bulk_file.created_at.iso8601).to eq value
  end

  it 'expires_atを出力できる' do
    value = '2022-12-09T00:00:00+09:00'
    bulk_file = Karaden::Model::BulkFile.new
    bulk_file.set_property('expires_at', value)
    expect(bulk_file.expires_at.iso8601).to eq value
  end
end
