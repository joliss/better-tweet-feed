#= require app

App.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'

  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'
      redirectsTo: 'whatwouldisee.index'

    whatwouldisee: Ember.Route.extend
      route: '/whatwouldisee'

      doLookUp: (router, e) ->
        if screenName = e.view.$('input[type=text]').val()
          router.transitionTo('root.whatwouldisee.show', user: App.User.create(screenName: screenName))

      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('whatwouldiseeForm')

      show: Ember.Route.extend
        route: '/:user'

        serialize: (router, context) ->
          return user: context.user.screenName

        deserialize: (router, context) ->
          return user: App.User.create(screenName: context.user)

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('whatwouldisee', context.user)