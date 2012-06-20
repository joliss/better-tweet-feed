#= require app

# Top-level

App.ApplicationController = Ember.Controller.extend()

App.ApplicationView = Ember.View.extend
  templateName: 'templates/application'

App.WhatwouldiseeFormController = Ember.Controller.extend()

App.WhatwouldiseeFormView = Ember.View.extend
  templateName: 'templates/whatwouldisee_form'

  init: ->
    @_super()

App.WhatwouldiseeController = Ember.Controller.extend
  userBinding: 'content'

App.WhatwouldiseeView = Ember.View.extend
  showRetweets: true
  showReplies: true

  templateName: 'templates/whatwouldisee'

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

  linkedText: Ember.computed(->
    # We should have a linking library that is conformant with
    # https://github.com/twitter/twitter-text-conformance/blob/master/autolink.yml
    # In the mean-time, we go very restrictive on the characters we allow, to
    # guard against XSS. When editing this, make sure that the replacement
    # statements can't mangle each other's HTML (e.g. [@#] in URL).
    $('<div/>').text(@getPath('content.text')).html() \
      .replace(/\b(https?:\/\/([-a-zA-Z0-9./]+))/, '<a href="$1">$2</a>') \
      .replace(/\B@([a-zA-Z0-9_]+)/g, (s, p1) ->
        "<a href='#{App.Helpers.profileUrl(p1)}'>@#{p1}</a>") \
      .replace(/\B#([a-zA-Z0-9_]+)/g, '<a href="https://twitter.com/search/%23$1">#$1</a>')
  ).property('content.text')

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
