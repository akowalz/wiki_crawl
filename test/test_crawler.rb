require 'minitest/autorun'
require_relative "../crawler.rb"

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