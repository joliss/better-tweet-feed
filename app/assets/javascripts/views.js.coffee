#= require app

# Top-level

App.ApplicationController = Ember.Controller.extend()

App.ApplicationView = Ember.View.extend
  templateName: 'templates/application'

App.WhatwouldiseeFormController = Ember.Controller.extend()

App.WhatwouldiseeFormView = Ember.View.extend
  templateName: 'templates/whatwouldisee_form'

App.WhatwouldiseeController = Ember.Controller.extend
  userBinding: 'content'

App.WhatwouldiseeView = Ember.View.extend
  templateName: 'templates/whatwouldisee'

# Components

App.TweetRowView = Ember.View.extend
  templateName: 'templates/tweet_row'
