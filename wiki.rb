require 'nokogiri'
require 'open-uri'

class Wiki

  VALID_WIKI_REGEX = /\/wiki\/[a-zA-Z0-9()_,-]+/
  attr_reader :title, :uri, :ext

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
    link_text(get_link_nodes)
  end

  def first_non_parened_link
    (linked_wikis - parened_links(first_p_text)).first
  end

  private 

    # grabs the title from a wiki page
    def get_title
      @doc.css('#firstHeading').xpath('//h1/span').text
    end

    # gets all links as array of strings like ['/wiki/example', ...]
    def get_link_nodes
      links = @doc.css('#mw-content-text').xpath('//div/p/a')
      if links.empty?
        @doc.css('#mw-content-text').xpath('//div/ul/li/a')
      else
        links
      end
    end

    def get_doc
      Nokogiri::HTML(open(@uri))
    end

    # used to strip out sidebar and internal links, etc
    def valid_wiki_link?(ext)
      match_text = ext.match(VALID_WIKI_REGEX)
      match_text.is_a?(MatchData) && match_text.to_s == ext
    end

    def link_text(link_nodes)
      link_nodes.map do |a|
        a.attribute('href').to_s 
      end.select { |a| valid_wiki_link?(a) }
    end

    def first_p_text
      @doc.css("#mw-content-text > p").first.to_s
    end

    def parened_links(text)
      text.match(/\(([^)]+)\)/).to_s.scan(VALID_WIKI_REGEX)
    end

end
