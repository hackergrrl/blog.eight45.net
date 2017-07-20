# Twitter timelines as RSS feeds

> 2015-10-25 13:28:14

## Where are my Twitter feeds?

Trying to keep tabs on Twitter is an exercise in futility: unless you're
following less than a dozen people it's impossible to keep up with every tweet
from the folks you care about. There are Lists, but the web UI around them is
awkward to use and manage. Alas! If only there was **some existing standardized
means** of keeping abreast of syndicated content.

...Oh yeah.


## RSS: an excellent standard

RSS (Rich Site Summary -- normal humans call it Really Simple Syndication) is an
example of an excellent standard: it's stored in a very well supported format
(XML) with tons of existing tooling. It is transport agnostic (though usually
delivered over HTTP). It makes a very minimal base set of assumptions (an
unbounded list of timestamped pieces of arbitrary 'content'). It is ignorant of
that content, leaving it up to the application layer. Finally, it is also very
durable (largely thanks to XML: you can have bogus or unknown fields not in the
RSS spec without complaint).

As such, there are a ton of RSS reader applications. There was time -- before
social media -- when RSS was the *de facto* means of subscribing to online
content. I believe it still **is** superior to subscribing via a closed network
(Facebook pages, Reddit posts, Twitter feeds), but support for RSS is waning.


## Hacking RSS feeds back into Twitter

Back in June 2013 Twitter nixed their old API and removed RSS feeds of user
timelines. Supporting RSS feeds is basically free -- it's no more expensive than
formatting a timeline into the HTML we see in our browsers -- so this was a
conscious decision to nix RSS support. Close *all* the silos!

So I put together
[twitter-rss-server](https://github.com/noffle/twitter-rss-server). It hosts an
HTTP server on your local machine that maps any single identifier route (e.g.
`http://localhost:6000/noffle`) to an RSS feed of their content. I used the
existing [rss-twitter](https://www.npmjs.com/package/rss-twitter) module from
npm for this. It worked!

However, closed silos struck again: Twitter user timelines can only be accessed
by the [Twitter API](https://dev.twitter.com/overview/documentation). This means
I need to [create a Twitter app](https://apps.twitter.com/) on Twitter's
website, save a bunch of identifiers (consumer key, consumer secret, access key,
access tokenalalarghalarghalargh---). I didn't want to push this painful
prerequisite onto the module's users. I'm trying to read a public feed!

Further research revealed a noble Perl monk known as
[ciderpunx](http://perlmonks.org/?node_id=373188) who, back in June 2013 when
Twitter killed RSS feeds, wrote a [Perl
script](http://perlmonks.org/?node_id=1039382) that would scrape Twitter's
website and format the result into an RSS feed. Today he uses it to power the
free service [TwitRss.me](https://twitrss.me/).


## Let's hack!

Eager to bring this tool to the npm ecosystem, I ported it to Node using
[xpath](https://www.npmjs.com/package/xpath) and
[xmldom](https://www.npmjs.com/package/xmldom) for HTML parsing, with
[request](https://www.npmjs.com/package/request) to pull down the raw HTML from
Twitter's public HTTP routes (e.g.
[http://twitter.com/noffle](http://twitter.com/noffle)).

This took the form of [latest-tweets](https://github.com/noffle/latest-tweets),
a module with a delightfully simple API:

{% highlight javascript %}
var latestTweets = require('latest-tweets')

latestTweets('noffle', function (err, tweets) {
  console.log(tweets)
})
{% endhighlight %}

This will print a JSON blob of my latest tweets to standard out.

All that remained was replacing
[twitter-rss-server](https://github.com/noffle/twitter-rss-server)'s dependency
on the Twitter API-dependent
[rss-twitter](https://www.npmjs.com/package/rss-twitter) with a wrapper module I
built on top of `latest-tweets`:
[twitter-rss-noauth](https://github.com/noffle/twitter-rss-noauth).
`twitter-rss-server` doesn't care where it gets its RSS feed content, so
swapping out the underlying implementation was trivial. Abstract away lower
layers using interfaces!

Huzzah! RSS feeds of Twitter timelines for everyone!

<br/>

 - [latest-tweets](https://github.com/noffle/latest-tweets)
 - [twitter-rss-noauth](https://github.com/noffle/twitter-rss-noauth)
 - [twitter-rss-server](https://github.com/noffle/twitter-rss-server)


