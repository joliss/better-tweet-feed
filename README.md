*Better Tweet Feed* is a Twitter web frontend running against the Twitter API
with OAuth.

It is built with [Ember.js](http://emberjs.com/) and
[CoffeeScript](http://coffeescript.org/).

This Rails app is only used to generate the asset files (JS & CSS), which
reside in `app/assets`.

It needs to run on top of the [Twitter API
Forwarder](https://github.com/joliss/twitter-forwarder).

```
git clone https://github.com/joliss/twitter-forwarder
git clone https://github.com/joliss/better-tweet-feed
cp better-tweet-feed/app/index.ejs twitter-forwarder/views/index.ejs
(cd better-tweet-feed; rails server) &  # launch asset server on :3000
cd twitter-forwarder; rails server      # launch API server on :5000
```

Now direct your browser to http://localhost:5000/ and you are all set.
