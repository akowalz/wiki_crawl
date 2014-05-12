require 'minitest/autorun'
require './crawler.rb'

class CrawlerTest < Minitest::Test

include WikiCrawl


  #def setup
    #@figs = Crawler.new('Figs')
    #@flower = Crawler.new('Flower')
  #end

  def test_title_is_correct
    assert_equal "Ficus", Crawler.wiki_title("Figs")
    assert_equal "Flower", Crawler.wiki_title("Flower")
  end

  def test_gets_first_link
    assert_match /wiki\/Blossom/, Crawler.first_link("Flower")
    assert_match /wiki\/Genus/, Crawler.first_link("Figs")
  end 

end