require 'nokogiri'
require 'open-uri'


module WikiCrawl
  class Crawler

    def self.wiki_document(ext)
      url = "http://en.wikipedia.org#{ext}"
      Nokogiri::HTML(open(url))
    end

    def self.wiki_title(ext)
      doc = wiki_document(ext)
      title = doc.css('#firstHeading') 
      if title.xpath('//h1/span/i').empty?
        title.xpath('//h1/span').text
      else
        title.xpath('//h1/span/i').text
      end
    end

    def self.first_link(ext)
      doc = wiki_document(ext)
      links = doc.css('#mw-content-text').xpath('//p/a')
      hrefs = links.map { |a| a.attribute('href').to_s }
      hrefs.select { |a| valid_wiki_link?(a) }.first
    end

    def self.valid_wiki_link?(link_text)
      link_text.match(/\/wiki\/[a-zA-Z0-9_]+/)
    end

    def self.full_wiki_link(link)
      "http://en.wikipedia.org#{link}"
    end

    def self.path_to_philosophy(page, visited = [])
      if wiki_title(page) == "Philosophy"
        path = visited.join(" =>\n")
        "Philsophy Reached! Path:\n#{path}"
      elsif visited.include?(page)
        "Loop found! Returned to #{wiki_title(page)}"
      else
        puts "Currently at: #{wiki_title(page)}, going to #{first_link(page)}"
        path_to_philosophy(first_link(page), visited + [page])
      end
    end


  end
end


