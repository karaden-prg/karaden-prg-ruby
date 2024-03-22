require 'webmock/rspec'
require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'securerandom'

RSpec.describe Karaden::Service::BulkMessageService do
  before do
    WebMock.enable!

    signed_url = 'https://example.com'
    bulk_file_response = {
      id: '741121d7-3f7e-ed85-9fac-28d87835528e',
      object: 'bulk_file',
      url: signed_url,
      created_at: '2023-12-01T15:00:00.0Z',
      expires_at: '2023-12-01T15:00:00.0Z',
    }
    request_options = Karaden::TestHelper.default_request_options_builder.build
    bulk_file_uri = "#{request_options.base_uri}/messages/bulks/files"
    stub_request(:post, bulk_file_uri).to_return(
      body: JSON.generate(bulk_file_response),
      status: 200,
      headers: { 'Content-Type' => 'application/json' }
    )

    bulk_message_response = {
      id: 'ef931182-80ff-611c-c878-871a08bb5a6a',
      object: 'bulk_message',
      status: 'processing',
      created_at: '2023-12-01T15:00:00.0Z',
      updated_at: '2023-12-01T15:00:00.0Z',
    }
    bulk_message_uri = "#{request_options.base_uri}/messages/bulks"
    stub_request(:post, bulk_message_uri).to_return(
      body: JSON.generate(bulk_message_response),
      status: 200,
      headers: { 'Content-Type' => 'application/json' }
    )

    stub_request(:put, signed_url).to_return(
      body: '',
      status: 200
    )
  end

  after do
    WebMock.disable!
  end

  it 'bulkMessageオブジェクトが返る' do
    file = Tempfile.new
    filename = file.path
    file.close

    request_options = Karaden::TestHelper.default_request_options_builder.build

    bulk_message = Karaden::Service::BulkMessageService.create(filename, request_options)

    expect(bulk_message.object).to eq 'bulk_message'
  end

  it 'ファイルが存在しない場合はエラー' do
    filename = 'test.csv'

    request_options = Karaden::TestHelper.default_request_options_builder.build

    expect do
      Karaden::Service::BulkMessageService.create(filename, request_options)
    end.to raise_error(Karaden::Exception::FileNotFoundException)
  end

  it 'ファイルがダウンロードできる' do
    Dir.mktmpdir do |dir|
      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
      mock_location_url = "https://example.com/#{SecureRandom.uuid}"
      file_content = 'file content'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'done',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      bulk_message_list_message_uri = "#{request_options.base_uri}/messages/bulks/#{id}/messages"
      stub_request(:get, bulk_message_list_message_uri).to_return(
        body: '',
        status: 302,
        headers: { 'Location' => mock_location_url }
      )

      filename = 'file.csv'
      content_disposition = "attachment;filename=\"#{filename}\";filename*=UTF-8''#{filename}"
      stub_request(:get, mock_location_url).to_return(
        body: file_content,
        status: 200,
        headers: { 'content-disposition' => content_disposition }
      )

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .build

      output = Karaden::Service::BulkMessageService.download(params, request_options)

      filename = File.join(File.realpath(dir), filename)

      expect(output).to eq true
      expect(File.file?(filename)).to eq true
      expect(File.read(filename)).to eq file_content

      File.delete(filename)
    end
  end

  it 'Locationから取得したURLにクエリパラメータがあっても正常にリクエストできること' do
    Dir.mktmpdir do |dir|
      mock_location_url = "https://example.com/#{SecureRandom.uuid}"
      with_query_param = "#{mock_location_url}?Key-Pair-Id=#{SecureRandom.uuid}"

      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
      file_content = 'file content'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'done',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      bulk_message_list_message_uri = "#{request_options.base_uri}/messages/bulks/#{id}/messages"
      stub_request(:get, bulk_message_list_message_uri).to_return(
        body: '',
        status: 302,
        headers: { 'Location' => with_query_param }
      )

      filename = 'file.csv'
      content_disposition = "attachment;filename=\"#{filename}\";filename*=UTF-8''#{filename}"
      stub_request(:get, with_query_param).to_return(
        body: file_content,
        status: 200,
        headers: { 'content-disposition' => content_disposition }
      )

      stub_request(:get, mock_location_url)

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .build

      output = Karaden::Service::BulkMessageService.download(params, request_options)

      filename = File.join(File.realpath(dir), filename)

      expect(output).to eq true
      expect(File.file?(filename)).to eq true
      expect(File.read(filename)).to eq file_content
      expect(WebMock).not_to have_requested(:get, mock_location_url)

      File.delete(filename)
    end
  end

  it 'bulk_messageのstatusがdone以外でリトライ回数を超過した場合はエラー' do
    Dir.mktmpdir do |dir|
      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'processing',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .with_max_retries(1)
        .with_retry_interval(10)
        .build

      expect do
        Karaden::Service::BulkMessageService.download(params, request_options)
      end.to raise_error(Karaden::Exception::BulkMessageShowRetryLimitExceedException)
    end
  end

  it '結果取得APIが202を返しリトライ回数を超過した場合はエラー' do
    Dir.mktmpdir do |dir|
      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'done',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      bulk_message_list_message_uri = "#{request_options.base_uri}/messages/bulks/#{id}/messages"
      stub_request(:get, bulk_message_list_message_uri).to_return(
        body: '',
        status: 202,
      )

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .with_max_retries(1)
        .with_retry_interval(10)
        .build

      expect do
        Karaden::Service::BulkMessageService.download(params, request_options)
      end.to raise_error(Karaden::Exception::BulkMessageListMessageRetryLimitExceedException)
    end
  end

  it 'bulk_messageのstatusがerrorの場合はエラー' do
    Dir.mktmpdir do |dir|
      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'error',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .with_max_retries(1)
        .with_retry_interval(10)
        .build

      expect do
        Karaden::Service::BulkMessageService.download(params, request_options)
      end.to raise_error(Karaden::Exception::BulkMessageCreateFailedException)
    end
  end

  it 'ファイルダウンロード処理にエラーが発生した場合は例外が飛ぶ' do
    Dir.mktmpdir do |dir|
      id ='82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'

      request_options = Karaden::TestHelper.default_request_options_builder.build
      bulk_message_response = {
        id: id,
        object: 'bulk_message',
        status: 'done',
        created_at: '2023-12-01T15:00:00.0Z',
        updated_at: '2023-12-01T15:00:00.0Z',
      }
      bulk_message_show_uri = "#{request_options.base_uri}/messages/bulks/#{id}"
      stub_request(:get, bulk_message_show_uri).to_return(
        body: JSON.generate(bulk_message_response),
        status: 200,
      )

      bulk_message_list_message_uri = "#{request_options.base_uri}/messages/bulks/#{id}/messages"
      stub_request(:get, bulk_message_list_message_uri).to_return(
        body: '',
        status: 302,
        headers: { 'Location' => '' }
      )

      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id('82bdf9de-a532-4bf5-86bc-c9a1366e5f4a')
        .with_directory_path(dir)
        .with_max_retries(1)
        .with_retry_interval(10)
        .build

      expect do
        Karaden::Service::BulkMessageService.download(params, request_options)
      end.to raise_error(Karaden::Exception::FileDownloadFailedException)
    end
  end
end
