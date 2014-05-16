require 'nokogiri'
require 'open-uri'

class Wiki

  attr_reader :title, :uri, :ext, :doc

  VALID_WIKI_REGEX = /\/wiki\/[a-zA-Z0-9()_,-]+/
  VALID_WIKI_REGEX_WHOLE_STRING = /\A\/wiki\/[a-zA-Z0-9()_,-]+\Z/

  # initialize using a /wiki/ extension like /wiki/Priates
  def initialize(ext)
    @uri = get_uri(ext)
    @ext = get_extension
    @doc ||= get_doc
    @title = get_title
  end


  def linked_wikis
    link_text(get_link_nodes)
  end

  def image_urls
    get_image_urls
  end

  def first_non_parened_link
    (linked_wikis - parened_links(first_p_text)).first
  end

  def inspect
    '#<Wiki Object ' + self.object_id.to_s +  ', page: ' + @ext + '>'
  end

  private

    def get_doc
      Nokogiri::HTML(open(@uri))
    end


    def content_div
      @doc.css('#mw-content-text')
    end

    def get_title
      @doc.css('#firstHeading').xpath('//h1/span').text
    end

    def get_link_nodes
      links = content_div.xpath('//div/p/a')
      if links.empty?
        content_div.xpath('//div/ul/li/a')
      else
        links
      end
    end

    def get_uri(ext)
      full_uri = "http://en.wikipedia.org#{ext}"
      if valid_wiki_link?(ext)
        full_uri
      else
        open(full_uri) do |response|
          response.base_uri.to_s
        end
      end
    end

    def get_extension
      @uri.scan(VALID_WIKI_REGEX).first
    end

    def get_image_urls
      @doc.css('.image').map do |a|
        "http://en.wikipedia.org" + a.attribute('href').text.to_s 
      end
    end

    # used to strip out links to help pages, etc.
    def valid_wiki_link?(ext)
      ext =~ Regexp.new(VALID_WIKI_REGEX_WHOLE_STRING)
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
