#= require app

# Top-level views

App.ApplicationController = Ember.Controller.extend()

App.ApplicationView = Ember.View.extend
  templateName: 'templates/application'

App.HomeController = Ember.Controller.extend
  homeTimeline: Ember.computed(->
    App.HomeTimeline.find()
  ).property()

App.HomeView = Ember.View.extend
  templateName: 'templates/home'

App.UserProfileController = Ember.Controller.extend
  userBinding: 'content'

App.UserProfileView = Ember.View.extend
  showRetweets: true
  showReplies: true

  templateName: 'templates/user_profile'

# Components

App.ProfileCardView = Ember.View.extend
  templateName: 'templates/profile_card'

App.TimelineView = Ember.View.extend
  showRetweets: true
  showReplies: true

  templateName: 'templates/timeline'

App.TweetRowView = Ember.View.extend
  templateName: 'templates/tweet_row'

  showRetweets: true
  showReplies: true

  visible: Ember.computed(->
    (@get('showRetweets') or not @getPath('content.retweetedStatus')) and \
      (@get('showReplies') or not @getPath('content.inReplyToUserId'))
  ).property('showRetweets', 'showReplies', 'content.retweeted', 'content.inReplyToUserId')

  linkifiedText: Ember.computed(->
    characters = @getPath('content.text').split('')
    characters = (if c == '<' then '&lt;' \
                  else if c == '>' then '&gt;' \
                  else if c == '&' then '&amp;' \
                  else if c == "'" then '&#39;' \
                  else if c == '"' then '&#34;' \
                  else c \
                  for c in characters)
    replaceCharacters = (indices, newText) ->
      index = indices[0]
      howMany = indices[1] - index
      characters.splice(index, howMany, newText, ('' for i in [1...howMany])...)
    for hashtag in @getPath('content.entities.hashtags') ? []
      replaceCharacters(hashtag.indices, "<a href='https://twitter.com/search/%23#{hashtag.text}'>##{hashtag.text}</a>")
    for userMention in @getPath('content.entities.userMentions') ? []
      replaceCharacters(userMention.indices, "<a href='#{App.Helpers.profileUrl(userMention.screenName)}'>@#{userMention.screenName}</a>")
    for url in (@getPath('content.entities.urls') ? []).concat(@getPath('content.entities.media') ? [])
      replaceCharacters(url.indices, "<a href='#{url.expandedUrl}'>#{url.displayUrl}</a>")
    characters.join ''
  ).property('content.text', 'content.entities')

  humanReadableDate: Ember.computed(->
    delta = ((+new Date) - (+Date.parse(@getPath('content.createdAt')))) / 1000
    if delta < 30
      # future dates are printed as "just now"
      'just now'
    else if delta < (60 * 59.5)
      "#{Math.round(delta/60)}m"
    else if delta < (3600 * 23.5)
      "#{Math.round(delta/3600)}h"
    else if delta < (3600 * 24 * 30.5)
      "#{Math.round(delta/3600/24)}d"
    else
      new Date(@getPath('content.createdAt')).toDateString()
  ).property('content.createdAt', 'App.date')
