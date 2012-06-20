#= require app

App.Helpers = Ember.Namespace.create()

App.Helpers.profileUrl = (screenName) ->
  return "#" unless /^[a-zA-Z0-9_]+$/.exec(screenName)
  #"https://twitter.com/#{screenName}"
  # Must have leading slash or middleclick doesn't work in Chrome
  # http://code.google.com/p/chromium/issues/detail?id=2913
  "/#/whatwouldisee/#{screenName}"

App.Helpers.camelizeObject = (o) ->
  for own key, value of o
    if (c = Ember.String.camelize(key)) != key
      o[c] = value
      delete o[key]
    if typeof value == 'object'
      App.Helpers.camelizeObject(value)

App.set('date', new Date)
setInterval(->
  App.set('date', new Date)
, 30000)
