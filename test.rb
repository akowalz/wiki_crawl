require 'minitest/autorun'
require './crawler.rb'
require './wiki.rb'

class WikiTest <Minitest::Test

  def setup
    @figs = Wiki.new('/wiki/figs')
    @sci = Wiki.new('/wiki/Science')
    @pm = Wiki.new('/wiki/Polymath')
    @com = Wiki.new('/wiki/Communes_of_France')
  end

  def test_titles_correct
    assert_equal "Ficus", @figs.title 
    assert_equal "Polymath", @pm.title
  end

  def test_gets_links
    assert_includes @pm.linked_wikis, '/wiki/Theology'
    assert_includes @figs.linked_wikis, '/wiki/Genus'
    assert @figs.linked_wikis.inject(true) { |m,a| m && (a.match /\/wiki\//) }
    assert @pm.linked_wikis.inject(true) { |m,a| m && (a.match /\/wiki\//) }
  end

  def test_first_link
    assert_equal '/wiki/Greek_language', @pm.linked_wikis.first
    assert_equal '/wiki/Genus', @figs.linked_wikis.first
    assert_equal '/wiki/Administrative_divisions', @com.linked_wikis.first
  end

  def test_first_non_language_link
    assert_equal '/wiki/Knowledge', @sci.non_blacklisted_wikis.first
  end

end

class CrawlerTest < Minitest::Test
  include Crawler

  def test_path_to_philosophy_from_proof
    assert_equal ["/wiki/Proof_(truth)",
                  "/wiki/Necessity_and_sufficiency",
                  "/wiki/Logic",
                  "/wiki/Philosophy"],
                  path_to_philosophy(Wiki.new('/wiki/Proof_(truth)'), [], false)
  end

end