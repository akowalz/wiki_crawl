require 'nokogiri'
require 'open-uri'
require './blacklist.rb'

class Wiki

  attr_reader :title, :uri, :linked_wikis, :ext

  # initialize using a /wiki/ extension like /wiki/Priates

  def initialize(ext)
    @ext = ext
    @uri = "http://en.wikipedia.org#{ext}"
    @doc ||= get_doc
    @title = get_title
  end

  # ignores all wikis on the blacklist and language wikis
  # tends to help with the parenthesis issues
  def non_blacklisted_wikis
    get_validated_links
  end

  def linked_wikis
    get_links
  end

  private 

    def get_validated_links
      linked_wikis.select do |w|
        !(BLACKLIST.include?(w) || 
          w.match(/\/wiki\/[a-zA-Z]+_language/))
      end
    end
    # grabs the title from a wiki page
    def get_title
      @doc.css('#firstHeading').xpath('//h1/span').text
    end

    # gets all links as array of strings like ['/wiki/example', ...]
    def get_links
      @doc.css('#mw-content-text').xpath('//div/p/a').map do |a|
        a.attribute('href').to_s 
      end.select { |a| valid_wiki_link?(a) }
    end

    def get_doc
      Nokogiri::HTML(open(@uri))
    end

    # used to strip out sidebar and internal links, etc
    def valid_wiki_link?(ext)
      match_text = ext.match(/\/wiki\/[a-zA-Z0-9()_]+/)
      match_text.is_a?(MatchData) && match_text.to_s == ext
    end

end
