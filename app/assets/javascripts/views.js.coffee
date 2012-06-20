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
  templateName: 'templates/whatwouldisee'

# Components

App.ProfileCardView = Ember.View.extend
  templateName: 'templates/profile_card'

App.TimelineView = Ember.View.extend
  templateName: 'templates/timeline'

App.TweetRowView = Ember.View.extend
  templateName: 'templates/tweet_row'

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
