#= require app

App.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'

  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('home')

    whatwouldisee: Ember.Route.extend
      route: '/whatwouldisee'

      doLookUp: (router, e) ->
        if screenName = $('.js-whatwouldisee-input').val()
          Ember.run =>
            router.transitionTo('root.whatwouldisee.show', App.User.find(screenName: screenName))
        $('.js-whatwouldisee-input').focus()

      show: Ember.Route.extend
        route: '/:user'

        serialize: (router, context) ->
          return user: context.screenName

        deserialize: (router, context) ->
          return App.User.find(screenName: context.user)

        connectOutlets: (router, context) ->
          router.get('applicationController').connectOutlet('whatwouldisee', context)
