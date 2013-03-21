require 'net/http'
require 'zlib'

module Download
  class HTTP
    def initialize options = {}
      @options = {
        http: {
          'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7',
          'Referer' => '',
        },
        port: 80,
        extract: true,
      }.merge options
    end

    def get src, dest
      tmpfile = download(src)
      if @options[:extract]
        FileUtils.mv tmpfile, dest
      else
        ext = File.extname(src)
        extract_to = tmpfile.gsub /#{ext}/, ''
        case ext
        when '.gz'
          Zlib::GzipReader.open(tmpfile) do |gz|
            File.open(dest, "wb"){|g| IO.copy_stream(gz, g) }
          end
        else
          FileUtils.mv tmpfile dest
        end
      end

      dest
    end

    def download src
      @options[:http]['Referer'] = src
      tmpfile = File.join Dir.tmpdir, File.basename(src)
      unless File.exists?(tmpfile)
        uri = URI.parse src
        response = Net::HTTP.start(uri.host, @options[:port]).get uri.path, @options[:http]
        File.binwrite tmpfile, response.body
      end

      tmpfile
    end
  end
end
