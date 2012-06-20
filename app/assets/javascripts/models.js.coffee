#= require app

# TODO: The Ajax calls should be moved into a separate persistence module, and
# we should use ember-data's data store.

# Return a query based on either id or screenName
getQuery = (options) ->
    if options.id
      throw 'invalid id' unless /^[0-9]+$/.exec(options.id)
      query = "user_id=#{options.id}"
    else
      throw 'no screen name' unless options.screenName
      throw 'invalid screen name' unless /^[a-zA-Z0-9_]+$/.exec(options.screenName)
      query = "screen_name=#{options.screenName}"

App.User = Ember.Object.extend
  screenName: null

  timeline: Ember.computed(->
    App.UserTimeline.find(screenName: @get('screenName'))
  ).property('screenName')

  profileUrl: Ember.computed(->
    App.Helpers.profileUrl(@get('screenName'))
  ).property('name')

  twitterProfileUrl: Ember.computed(->
    "https://twitter.com/#{@get('screenName')}"
  ).property('screenName')

  profileCardImageUrl: Ember.computed(->
    return undefined unless @get('profileImageUrl')?
    @get('profileImageUrl').replace(/_normal(\.[a-zA-Z]+)/, '_reasonably_small$1')
  ).property('profileImageUrl')

App.User.reopenClass
  find: (options) ->
    user = App.User.create(options)
    query = getQuery(options)
    $.ajax
      method: 'get'
      url: "/twitter-api/1/users/lookup.json?#{query}"
      success: (data) =>
        userData = data[0]
        App.Helpers.camelizeObject(userData)
        if userData.status
          # Do not rely on status attribute, since it is not included in users
          # embedded in timelines
          delete userData.status
        user.set('name', userData.name)
        user.setProperties userData
        user.set('loaded', true)
    user

App.Tweet = Ember.Object.extend()

App.UserTimeline = Ember.ArrayProxy.extend
  screenName: null

App.UserTimeline.reopenClass
  find: (options) ->
    userTimeline = App.UserTimeline.create(options)
    userTimeline.set('content', Ember.A([]))
    query = getQuery(options)
    $.ajax
      method: 'get'
      url: "/twitter-api/1/statuses/user_timeline.json?#{query}&include_rts=true&include_entities=true&count=50"
      success: (data) =>
        userTimeline.pushObjects Ember.A(data).map (status) ->
          App.Helpers.camelizeObject(status)
          status = status.retweetedStatus ? status
          status.user = App.User.create(status.user)
          App.Tweet.create(status)
        userTimeline.set('loaded', true)
    userTimeline
