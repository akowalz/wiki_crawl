### Wiki Crawler


The beginnings of a a web crawler for Wikipedia, written because I was interested in programming the "clicks to philosophy" algorithm and ended up fleshing it out more than that.

Included is very barebones API for Wikipedia, parsing the webpages into an object that can be worked with.

    irb > w = Wiki.new("/wiki/Tortilla")
      => #<Wiki:0x007f87098f1ac8 @ext="/wiki/Tortilla", @uri="http://en.wikipedia.org/wiki/Tortilla", ...>
    irb > w.title
      => "Tortilla"
    irb > w.linked_wikis.first
      => "/wiki/Flatbread"

Check out `wiki.rb` for full spec on `Wiki` objects.

#### Crawling

The original idea behind this library was making something that could crawl wikipedia articles, clicking the first link on a page and running until it found the page for Philosophy.  It's a cool trick works most of the time.  The wrinkle is that the link is supposed to be non-parenthesized, which ended up being somewhat tough for my HTML parser to handle. The workaround for now is exlcuding links on blacklist I'm keeping.  Mostly it has language wikis, as an article will often stary, for example: *"Science (from the Latin ...)"*.  And we don't want to click Latin because it ends up down a rabbit hole of links and articles.

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

I also used the Wikipedia's Special:Random page to make a function that will get a random page and try to get to philosophy.  

    irb > random_philosophy_crawl
    Crawling...currently on Henry Perry (boxer) (/wiki/Special:Random)
    Crawling...currently on United Kingdom (/wiki/United_Kingdom)
    Crawling...currently on Europe (/wiki/Europe)
    Crawling...currently on Continent (/wiki/Continent)
    Crawling...currently on Land (/wiki/Landmass)
    Crawling...currently on Earth (/wiki/Earth)
    Crawling...currently on World (/wiki/World)
    Crawling...currently on Human (/wiki/Human)
    Crawling...currently on Hominini (/wiki/Hominini)
    Crawling...currently on Tribe (biology) (/wiki/Tribe_(biology))
    Crawling...currently on Biology (/wiki/Biology)
    Crawling...currently on Natural science (/wiki/Natural_science)
    Crawling...currently on Science (/wiki/Science)
    Crawling...currently on Knowledge (/wiki/Knowledge)
    Crawling...currently on Fact (/wiki/Fact)
    Crawling...currently on Proof (truth) (/wiki/Proof_(truth))
    Crawling...currently on Necessity and sufficiency (/wiki/Necessity_and_sufficiency)
    Crawling...currently on Logic (/wiki/Logic)
    Philosophy Found!
     => ["/wiki/Special:Random", "/wiki/United_Kingdom", "/wiki/Europe", "/wiki/Continent", "/wiki/Landmass", "/wiki/Earth", "/wiki/World", "/wiki/Human", "/wiki/Hominini", "/wiki/Tribe_(biology)", "/wiki/Biology", "/wiki/Natural_science", "/wiki/Science", "/wiki/Knowledge", "/wiki/Fact", "/wiki/Proof_(truth)", "/wiki/Necessity_and_sufficiency", "/wiki/Logic", "/wiki/Philosophy"]