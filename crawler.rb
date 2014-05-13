require 'nokogiri'
require 'open-uri'
require './wiki.rb'

module Crawler

  # takes a Wiki object and returns a path to Philosophy, or a loop, as an Array
  def path_to_philosophy(wiki, visited = [], verbose = true)
    return "path_to_philosopy must be passed a Wiki object" unless wiki.Wiki?
    if wiki.ext == "/wiki/Philosophy"
      puts "Philosophy Found!" if verbose
      visited.push(wiki.ext)
    elsif visited.include?(wiki.ext)
      puts "Loop Found. Returned to #{wiki.title} (#{wiki.ext})" if verbose
      visited.push(wiki.ext)
    else 
      puts "Crawling...currently on #{wiki.title} (#{wiki.ext})" if verbose  
      path_to_philosophy(Wiki.new(wiki.non_language_wikis.first),
                         visited.push(wiki.ext),
                         verbose)
    end
  end
end


