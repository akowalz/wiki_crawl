require 'nokogiri'
require 'open-uri'

class Wiki

  def initialize(ext)
    @uri = "http://en.wikipedia.org#{ext}"
    @title = get_title(ext)
    @links = get_links(ext)
  end

  

end