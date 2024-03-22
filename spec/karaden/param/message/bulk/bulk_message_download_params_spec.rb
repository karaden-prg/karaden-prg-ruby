require 'webmock/rspec'
require 'tmpdir'
require 'tempfile'
require 'fileutils'

RSpec.describe Karaden::Param::Message::Bulk::BulkMessageDownloadParams do
  let(:id_provider) do
    ['', nil]
  end
  let(:max_retries_provider) do
    [0, 6, -1, 1.1, nil]
  end
  let(:retry_interval_provider) do
    [9, 61, -1, 10.1, nil]
  end

  it 'idが空文字や未指定はエラー' do
    id_provider.each do |value|
      expect do
        params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_id(value)
        .build
        params.validate
      end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
        messages = e.error.errors.property('id')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it 'directory_pathが存在しない値の場合はエラー' do
    expect do
      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
      .with_directory_path('invalid')
      .build
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('directory_path')
      expect(messages.is_a?(Array)).to eq true
    }
  end

  it 'directory_pathがファイルを指定している場合はエラー' do
    Tempfile.create('test_') do |f|
      expect do
        params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_directory_path(f.path)
        .build
        params.validate
      end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
        messages = e.error.errors.property('directory_path')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it '指定されたdirectory_pathに読み取り権限がない場合はエラー' do
    temp_dir = '/tmp/testdir'
    FileUtils.mkdir_p(temp_dir, mode: 0o377)
    expect do
      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
      .with_directory_path(temp_dir)
      .build
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('directory_path')
      expect(messages.is_a?(Array)).to eq true
    }
    FileUtils.chmod(0o777, temp_dir)
    FileUtils.rm_rf(temp_dir)
  end

  it '指定されたdirectory_pathに書き込み権限がない場合はエラー' do
    temp_dir = '/tmp/testdir'
    FileUtils.mkdir_p(temp_dir, mode: 0o577)
    expect do
      params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
      .with_directory_path(temp_dir)
      .build
      params.validate
    end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
      messages = e.error.errors.property('directory_path')
      expect(messages.is_a?(Array)).to eq true
    }
    FileUtils.chmod(0o777, temp_dir)
    FileUtils.rm_rf(temp_dir)
  end

  it 'max_retriesが未指定や0以下6以上または小数値はエラー' do
    max_retries_provider.each do |value|
      expect do
        params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_max_retries(value)
        .build
        params.validate
      end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
        messages = e.error.errors.property('max_retries')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end

  it 'retry_intervalが未指定や9以下61以上または小数値はエラー' do
    retry_interval_provider.each do |value|
      expect do
        params = Karaden::Param::Message::Bulk::BulkMessageDownloadParams.new_builder
        .with_retry_interval(value)
        .build
        params.validate
      end.to raise_error(Karaden::Exception::InvalidParamsException) { |e|
        messages = e.error.errors.property('retry_interval')
        expect(messages.is_a?(Array)).to eq true
      }
    end
  end
end

RSpec.describe Karaden::Param::Message::Bulk::BulkMessageDownloadParamsBuilder do
  it 'idを入力できる' do
    expected = '82bdf9de-a532-4bf5-86bc-c9a1366e5f4a'
    params = Karaden::Param::Message::Bulk::BulkMessageDownloadParamsBuilder.new
      .with_id(expected)
      .build
    expect(params.id).to eq expected
  end

  it 'directory_pathを入力できる' do
    expected = 'pass'
    params = Karaden::Param::Message::Bulk::BulkMessageDownloadParamsBuilder.new
      .with_directory_path(expected)
      .build
    expect(params.directory_path).to eq expected
  end

  it 'max_retriesを入力できる' do
    expected = 1
    params = Karaden::Param::Message::Bulk::BulkMessageDownloadParamsBuilder.new
      .with_max_retries(expected)
      .build
    expect(params.max_retries).to eq expected
  end

  it 'retry_intervalを入力できる' do
    expected = 10
    params = Karaden::Param::Message::Bulk::BulkMessageDownloadParamsBuilder.new
      .with_retry_interval(expected)
      .build
    expect(params.retry_interval).to eq expected
  end
end
