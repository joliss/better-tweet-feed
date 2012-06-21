#= require app

App.Router = Ember.Router.extend
  enableLogging: true
  location: 'hash'

  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('home')

    userProfile: Ember.Route.extend
      route: '/:user'

      serialize: (router, context) ->
        return user: context.screenName

      deserialize: (router, context) ->
        return App.User.find(screenName: context.user)

      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('userProfile', context)

      doLookUp: (router, e) ->
        if screenName = $('.js-user-search-input').val()
          Ember.run =>
            router.transitionTo('root.userProfile', App.User.find(screenName: screenName))
        $('.js-user-search-input').focus()

