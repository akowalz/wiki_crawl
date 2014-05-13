require 'minitest/autorun'
require './crawler.rb'
require './wiki.rb'

class WikiTest <Minitest::Test

  def setup
    @figs = Wiki.new('/wiki/figs')
    @sf = Wiki.new('/wiki/San_Fransico')
  end

  def test_titles_correct
    assert_equal "Ficus", @figs.title 
    assert_equal "San Francisco", @sf.title
  end

  def test_gets_links
    assert_includes @sf.linked_wikis, '/wiki/Northern_California'
    assert_includes @figs.linked_wikis, '/wiki/Genus'
    assert @figs.linked_wikis.inject(true) { |m,a| m && (a.match /\/wiki\//) }
    assert @sf.linked_wikis.inject(true) { |m,a| m && (a.match /\/wiki\//) }
  end

end