#= require app

App.Helpers = Ember.Namespace.create()

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

# Cookie handling in JavaScript, oh the agony!
App.set 'signedIn', !!/oauthaccesstoken/i.exec(document.cookie)
