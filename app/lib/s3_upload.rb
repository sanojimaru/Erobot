require 'mime/types'
require 'aws/s3'

ACCESS_KEY_ID = "AKIAJ4BHY5SLD63HC4BQ"
SECRET_ACCESS_KEY = "c7y85smklvxTZkOMhxtZrWkaW+w+ToMaMH+ckum1"

class S3Upload
  def initialize
    AWS::S3::DEFAULT_HOST.replace "s3-ap-northeast-1.amazonaws.com"
    AWS::S3::Base.establish_connection!(
      :access_key_id => ACCESS_KEY_ID,
      :secret_access_key => SECRET_ACCESS_KEY
    )
    @bucket = Rails.env == 'production' ? "erobot-production" : "erobot-development"
  end

  def put(local_file, prefix = nil)
    base_name = File.basename local_file
    mime_type = MIME::Types.type_for local_file
    upload_file_path = File.join prefix, base_name

    stored = AWS::S3::S3Object.store(
      upload_file_path,
      File.open(local_file),
      @bucket,
      :content_type => mime_type.first.to_s,
      :access => :public_read
    )

    "http://#{AWS::S3::DEFAULT_HOST}/#{@bucket}/#{upload_file_path}"
  end
end
