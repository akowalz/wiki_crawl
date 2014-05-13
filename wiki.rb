require 'nokogiri'
require 'open-uri'
require './language_wikis'

class Wiki

  attr_reader :title, :uri, :linked_wikis, :ext

  def initialize(ext)
    @ext = ext
    @uri = "http://en.wikipedia.org#{ext}"
    @doc ||= get_doc
    @title = get_title
    @linked_wikis = get_links
  end

  def Wiki?
    true
  end

  def non_language_wikis
    @linked_wikis.select do |w|
      !LANG_WIKIS.include? w
    end
  end

  private 

  def get_title
    @doc.css('#firstHeading').xpath('//h1/span').text
  end

  def get_links
    @doc.css('#mw-content-text').xpath('//p/a').map do |a|
      a.attribute('href').to_s 
    end.select { |a| valid_wiki_link?(a) }
  end

  def get_doc
    Nokogiri::HTML(open(@uri))
  end

  def valid_wiki_link?(link)
    link.match(/\/wiki\/[a-zA-Z0-9()_]+/)
  end

end
