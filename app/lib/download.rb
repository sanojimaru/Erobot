require 'net/http'

class Download
  def get url, dir
    filename = File.basename(url)
    fullpath = "#{dir}/#{filename}"

    open(fullpath, 'wb') do |file|
      file.puts Net::HTTP.get_response(URI.parse(url)).body
    end

    fullpath
  end
end
