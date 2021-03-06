#= require app

App.Router = Ember.Router.extend
  location: 'history'

  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'
      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('home')

    userProfile: Ember.Route.extend
      route: '/:user'

      serialize: (router, context) ->
        return user: context.get('screenName')

      deserialize: (router, context) ->
        return App.User.find(screenName: context.user)

      connectOutlets: (router, context) ->
        router.get('applicationController').connectOutlet('userProfile', context)

    goToUserProfile: Ember.Route.transitionTo('root.userProfile')
    goToRoot: Ember.Route.transitionTo('root.index')

    # Called as action on the navigation bar. This should live someplace else.
    doLookUp: (router, e) ->
      if screenName = $('.js-user-search-input').val().replace(/^@/, '')
        Ember.run =>
          router.transitionTo('root.userProfile', App.User.find(screenName: screenName))
      $('.js-user-search-input').val('').blur()
