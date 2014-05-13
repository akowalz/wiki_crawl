### Wiki Crawler


The beginnings of a a web crawler for Wikipedia, written because I was interested in programming the "clicks to philosophy" algorithm and ended up fleshing it out more than that.

Included is very barebones class for Wikipedia articles that will spwan `Wiki` objects when called with the extension link.

    irb > w = Wiki.new("/wiki/Tortilla")
      => #<Wiki:0x007f87098f1ac8 @ext="/wiki/Tortilla", @uri="http://en.wikipedia.org/wiki/Tortilla", ...>
    irb > w.title
      => "Tortilla"
    irb > w.linked_wikis.first
      => "/wiki/Flatbread"

Check out `wiki.rb` for full spec on `Wiki` objects.

#### Crawling

The original idea behind this library was making something that could crawl wikipedia articles, clicking the first link on a page and running until it found the page for Philosophy.  It's a cool trick works most of the time.  The wrinkle I had mixed results overcoming is that the link is supposed to be non-parenthesized, which ended up being somewhat tough for my HTML parser to handle. The workaround for now (where most of the mishaps seemed to be happening) was exlcuding any links to Language pages, as an article will often stary, for example: *"Science (from the Latin ...)"*, and we end up clicking Latin. So I have a sort of blacklist of language links I'll keep expanding until I find a better way to deal with this.

Anyway, here's an example of how the crawler works, the algorithm is very simple.The function takes a `Wiki` object and returns an array of wiki extensions as strings.

    irb > include Crawler
     => Object 
    irb > path_to_philosophy(Wiki.new("/wiki/Science"))
    Crawling...currently on Science (/wiki/Science)
    Crawling...currently on Knowledge (/wiki/Knowledge)
    Crawling...currently on Fact (/wiki/Fact)
    Crawling...currently on Proof (truth) (/wiki/Proof_(truth))
    Crawling...currently on Necessity and sufficiency (/wiki/Necessity_and_sufficiency)
    Crawling...currently on Logic (/wiki/Logic)
    Philosophy Found!
     => ["/wiki/Science", "/wiki/Knowledge", "/wiki/Fact", "/wiki/Proof_(truth)", "/wiki/Necessity_and_sufficiency", "/wiki/Logic", "/wiki/Philosophy"] 