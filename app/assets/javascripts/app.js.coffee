window.App = Ember.Application.create()

$ ->
  App.initialize()
  if !App.get('signedIn')
    $('#application-info').show()
