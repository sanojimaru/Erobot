# -*- coding: utf-8 -*-
class MecabDic
  IGO_PATH = Rails.root.join 'vendor', 'igo'
  MECAB_DIC_DIRNAME = 'mecab-ipadic-2.7.0-20070801'

  class << self
    def generate download = false
      if download
        download_wikipedia
        download_hatena
      end

      generate_wikipedia
      generate_hatena

      bin_path = File.join IGO_PATH, 'igo-0.4.5.jar'
      dic_path = File.join IGO_PATH, 'ipadic'
      data_path = File.join IGO_PATH, MECAB_DIC_DIRNAME
      system("java -Xmx1024m -cp #{bin_path} net.reduls.igo.bin.BuildDic #{dic_path} #{data_path} EUC-JP")
    end

    def download_hatena
      filepath = File.join IGO_PATH, 'data', 'hatena.csv'
      dl = Download::HTTP.new
      dl.get 'http://d.hatena.ne.jp/images/keyword/keywordlist_furigana.csv', filepath
    end

    def generate_hatena
      datafile = File.join IGO_PATH, 'data', 'hatena.csv'
      csvfile = File.join IGO_PATH, MECAB_DIC_DIRNAME, 'hatena.csv'
      FileUtils.rm csvfile rescue nil
      File.open(csvfile, 'wb') do |out|
        File.open(datafile, 'rb').each_line do |line|
          word = line.encode('UTF-8', 'EUC-JP', undef: :replace, invalid: :replace).strip.split("\t").reverse.first
          next unless word
          next if word =~ /,|_/

          cost = (-400 * word.length ** 1.5).to_i
          cost = -32768 if cost < -32768

          row = "#{word},-1,-1,#{cost},名詞,固有名詞,*,*,*,*,#{word}\n"
          out.write row.encode 'EUC-JP', 'UTF-8', invalid: :replace, undef: :replace
        end
      end
    end

    def download_wikipedia
      filepath = File.join IGO_PATH, 'data', 'wikipedia.txt'
      dl = Download::HTTP.new
      dl.get 'http://dumps.wikimedia.org/jawiki/latest/jawiki-latest-all-titles-in-ns0.gz', filepath
    end

    def generate_wikipedia
      datafile = File.join IGO_PATH, 'data', 'wikipedia.txt'
      csvfile = File.join IGO_PATH, MECAB_DIC_DIRNAME, 'wikipedia.csv'
      FileUtils.rm csvfile rescue nil
      File.open(csvfile, 'wb') do |out|
        File::open(datafile).each_line do |line|
          word = line.strip
          next if word =~ /^\./
          next if word =~ /^[0-9]{1,100}$/
          next if word =~ /[0-9]{4}./
          next if word =~ /,|_/
          next if word.length < 2

          cost = (-400 * word.length ** 2).to_i
          cost = -32768 if cost < -32768

          row = "#{word},-1,-1,#{cost},名詞,固有名詞,*,*,*,*,#{word}\n"
          out.write row.encode 'EUC-JP', 'UTF-8', invalid: :replace, undef: :replace
        end
      end
    end
  end
end
