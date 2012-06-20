#= require app

# TODO: Move Ajax calls into separate persistence module

App.User = Ember.Object.extend
  screenName: null

  timeline: Ember.computed(->
    App.UserTimeline.create(screenName: @get('screenName'))
  ).property('screenName')

App.Tweet = Ember.Object.extend()

App.UserTimeline = Ember.ArrayProxy.extend
  screenName: null

  init: ->
    @set('content', Ember.A([]))
    $.ajax
      method: 'get'
      url: "/twitter-api/1/statuses/user_timeline.json?screen_name=#{@get('screenName')}&include_rts=true&count=50" # TODO: validate screenName
      success: (data) =>
        @pushObjects Ember.A(data).map (status) ->
          status = status.retweeted_status ? status
          App.Tweet.create(status)
