### Wiki Crawler


A basic API and web crawler for Wikipedia, written because I was interested in programming the "How many clicks to philosophy" algorithm and ended up making it extensible so it would be easy to implement other crawling algorithms in the future.

Included is a very simple API for Wikipedia articles.  Pages get packaged into `Wiki` objects which have a few useful properties.

    irb > w = Wiki.new("/wiki/Tortilla")
      => #<Wiki:0x007f87098f1ac8 @ext="/wiki/Tortilla", @uri="http://en.wikipedia.org/wiki/Tortilla", ...>
    irb > w.title
      => "Tortilla"
    irb > w.linked_wikis.first
      => "/wiki/Flatbread"

Check out `wiki.rb` for full spec on `Wiki` objects.

#### Crawling

The motivation behind the API was a to make a crawler that could go through Wikipedia pages, clicking the first non-parenthesized linked Wikipedia page, and continue recursively until it finds '/wiki/Philosophy'.  

The algorithm is basically as follows:

* **Are we on 'Philosophy'?** We're done! Return the list of pages visited so far.

* **Have we been here before?** We're stuck in a loop! Return the list of pages visisted so far.

* **Otherwise, keep crawling!** Recur on the first link on this page, adding the current page to list of pages visited so far.

Here's an example of the algorithm in action, it manipules the aforementioned `Wiki` objects.

        irb > include Crawler
            => Object
        irb > random_philosophy_crawl
        Crawling...currently on Ministry of Environment and Forests (India) (/wiki/Ministry_of_Environment_and_Forests_(India))
        Crawling...currently on Government of India (/wiki/Government_of_India)
        Crawling...currently on Constitution of India (/wiki/Constitution_of_India)
        Crawling...currently on India (/wiki/India)
        Crawling...currently on South Asia (/wiki/South_Asia)
        Crawling...currently on South (/wiki/South)
        Crawling...currently on Noun (/wiki/Noun)
        Crawling...currently on Part of speech (/wiki/Part_of_speech)
        Crawling...currently on Grammar (/wiki/Grammar)
        Crawling...currently on Linguistics (/wiki/Linguistics)
        Crawling...currently on Science (/wiki/Science)
        Crawling...currently on Knowledge (/wiki/Knowledge)
        Crawling...currently on Fact (/wiki/Fact)
        Crawling...currently on Proof (truth) (/wiki/Proof_(truth))
        Crawling...currently on Necessity and sufficiency (/wiki/Necessity_and_sufficiency)
        Crawling...currently on Logic (/wiki/Logic)
        Philosophy Found in 16 clicks!
         => ["/wiki/Ministry_of_Environment_and_Forests_(India)", "/wiki/Government_of_India", "/wiki/Constitution_of_India", "/wiki/India", "/wiki/South_Asia", "/wiki/South", "/wiki/Noun", "/wiki/Part_of_speech", "/wiki/Grammar", "/wiki/Linguistics", "/wiki/Science", "/wiki/Knowledge", "/wiki/Fact", "/wiki/Proof_(truth)", "/wiki/Necessity_and_sufficiency", "/wiki/Logic", "/wiki/Philosophy"] 

`random_philosophy_crawl` takes advantage of Wikipedia's '/wiki/Special:Random' page to fetch a random page to crawl from (it's somewhat mesmerizing to watch).

`path_to_philosophy` does the same thing, but takes a `Wiki` object (or an extension used to create one) so you can crawl from somewhere specific.