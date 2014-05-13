require 'nokogiri'
require 'open-uri'

class Wiki

  attr_reader :title, :uri, :linked_wikis

  def initialize(ext)
    @ext = ext
    @uri = "http://en.wikipedia.org#{ext}"
    @title = get_title
    @linked_wikis = get_links
  end

  def doc
    Nokogiri::HTML(open(@uri))
  end

  private 

  def get_title
    doc.css('#firstHeading').xpath('//h1/span').text
  end

  def get_links
    doc.css('#mw-content-text').xpath('//p/a').map do
     |a| a.attribute('href').to_s 
    end.select { |a| valid_wiki_link?(a) }
  end

  def valid_wiki_link?(link)
    link.match(/\/wiki\//)
  end

end