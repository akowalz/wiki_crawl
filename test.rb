require 'minitest/autorun'
require './crawler.rb'
require './wiki.rb'

class WikiTest <Minitest::Test

  def setup
    @figs = Wiki.new('/wiki/figs')
    @sci = Wiki.new('/wiki/Science')
    @pm = Wiki.new('/wiki/Polymath')
    @com = Wiki.new('/wiki/Communes_of_France')
    @clop = Wiki.new('/wiki/Clopton_(name)')
    @glang = Wiki.new('/wiki/Greek_language')
    @khaz = Wiki.new('/wiki/Government_of_Kazakhstan')
  end

  def test_titles_correct
    assert_equal "Ficus", @figs.title 
    assert_equal "Polymath", @pm.title
    assert_equal "Science", @sci.title
    assert_equal "Communes of France", @com.title
    assert_equal "Clopton (name)", @clop.title
    assert_equal "Greek language", @glang.title
    assert_equal "Government of Kazakhstan", @khaz.title
  end

  def test_extensions_correct
    assert_equal '/wiki/figs', @figs.ext
    assert_equal '/wiki/Science', @sci.ext
    assert_equal '/wiki/Polymath', @pm.ext
    assert_equal '/wiki/Communes_of_France', @com.ext
    assert_equal '/wiki/Clopton_(name)', @clop.ext
    assert_equal '/wiki/Greek_language', @glang.ext
    assert_equal '/wiki/Government_of_Kazakhstan', @khaz.ext
    assert !(Wiki.new('/wiki/Special:Random').ext == '/wiki/Special:Random'),
            "Special:Random should get the redirected URI's extension"
  end

  def test_gets_links
    assert_includes @figs.linked_wikis, '/wiki/Fruit'
    assert_includes @pm.linked_wikis, '/wiki/Theology'
    assert_includes @clop.linked_wikis, '/wiki/David_Clopton'
    assert_includes @sci.linked_wikis, '/wiki/Chemistry'
    assert_includes @com.linked_wikis, '/wiki/France'
    assert_includes @glang.linked_wikis, '/wiki/Platonic_dialogue'
    assert_includes @khaz.linked_wikis, '/wiki/Astana'
  end

  def test_first_link
    assert_equal '/wiki/Greek_language', @pm.linked_wikis.first
    assert_equal '/wiki/Genus', @figs.linked_wikis.first
    assert_equal '/wiki/Administrative_divisions', @com.linked_wikis.first
  end

  def test_non_parened_links
    assert_equal '/wiki/Indo-European_languages',
                 @glang.first_non_parened_link
    assert_equal '/wiki/Presidential_system',
                 @khaz.first_non_parened_link
    assert_equal '/wiki/Genus', @figs.first_non_parened_link 
    assert_equal '/wiki/Knowledge', @sci.first_non_parened_link 
    assert_equal '/wiki/David_Clopton', @clop.first_non_parened_link 
    assert_equal '/wiki/Administrative_divisions', @com.first_non_parened_link 
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
    assert_equal ["/wiki/Logic", "/wiki/Philosophy"], 
                  path_to_philosophy('/wiki/Logic', [], false)              

  end

  def test_ruby_includes_language
  assert_includes path_to_philosophy('/wiki/Ruby_(programming_language)',[],false),
                  "/wiki/Dynamic_programming_language"
  end
end
