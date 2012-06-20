#= require app

App.User = Ember.Object.extend
  screenName: null

  timeline: Ember.computed(->
    App.UserTimeline.create(screenName: @get('screenName'))
  ).property('screenName')

  profileUrl: Ember.computed(->
    App.Helpers.profileUrl(@get('screenName'))
  ).property('name')

App.Tweet = Ember.Object.extend()

App.UserTimeline = Ember.ArrayProxy.extend
  screenName: null

  init: ->
    @_super()
    @set('content', Ember.A([]))
    # TODO: This Ajax call should be moved into a separate persistence module,
    # and we should use ember-data's data store instead of hooking into init.
    $.ajax
      method: 'get'
      url: "/twitter-api/1/statuses/user_timeline.json?screen_name=#{@get('screenName')}&include_rts=true&count=50" # TODO: validate screenName
      success: (data) =>
        @pushObjects Ember.A(data).map (status) ->
          camelizeObject = (o) ->
            for key, value of o
              if (c = Ember.String.camelize(key)) != key
                o[c] = value
                delete o[key]
              if typeof value == 'object'
                camelizeObject(value)
          camelizeObject(status)
          status = status.retweetedStatus ? status
          status.user = App.User.create(status.user)
          App.Tweet.create(status)
