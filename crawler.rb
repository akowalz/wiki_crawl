require 'nokogiri'
require 'open-uri'
require './wiki.rb'

module Crawler

  # takes a Wiki object and returns a path to Philosophy, or a loop, as an Array
  def path_to_philosophy(wiki, visited = [], verbose = true)

    wiki = Wiki.new(wiki) unless wiki.is_a?(Wiki)  

    if wiki.ext == "/wiki/Philosophy"
      puts "Philosophy Found in #{visited.length} clicks!" if verbose
      visited.push(wiki.ext)

    elsif visited.include?(wiki.ext)
      puts "Loop Found. Returned to #{wiki.title} (#{wiki.ext})" if verbose
      visited.push(wiki.ext)

    else 
      puts "Crawling...currently on #{wiki.title} (#{wiki.ext})" if verbose  
      path_to_philosophy(Wiki.new(wiki.first_non_parened_link),
                         visited.push(wiki.ext),
                         verbose)
    end
    
  end

  def random_philosophy_crawl
    path_to_philosophy(Wiki.new('/wiki/Special:Random'))
  end
  
end


