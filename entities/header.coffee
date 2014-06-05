define (require, exports, module) ->
    App = require 'app/application'
    App.module 'Entities', (Entities, App) ->
        Entities.Header = Backbone.Model.extend()

        Entities.HeaderCollection = Backbone.Collection.extend(
            model: Entities.Header
        )

        initializeHeaders = () ->
            Entities.headers = new Entities.HeaderCollection([
                {name: 'Tables', url: 'tables'},
                {name: 'About', url: 'about'}
            ])

        API =
            getHeaders: () ->
                if (typeof Entities.headers is 'undefined') or Entities.header?
                    do initializeHeaders

        App.reqres.setHandler 'header:entities', ()->
            do API.getHeaders
