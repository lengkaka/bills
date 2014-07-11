define (require, exports, module) ->
    App = require 'app/application'
    App.module 'NavApp.List', (List, App) ->
        List.Header = Marionette.CompositeView.extend(
            template: require 'templates/header/header.tpl'
            tagName: 'li'

            events:
                'click a': 'navigate'
            modelEvents:
                'change': 'onRender'

            navigate: (e)->
                do e.preventDefault
                @trigger 'navigate', @model

            onRender: ()->
                if @model.get 'status'
                    @$el.addClass 'active'
        )

        List.Headers = Marionette.CompositeView.extend(
            template: require 'templates/header/headers.tpl'
            className: 'navbar navbar-inverse navbar-fixed-top'
            itemView: List.Header
            itemViewContainer: 'ul'

            evnets:
                'click a.brand': 'brandClicked'
            brandClicked: () ->
                do e.preventDefault
                @trigger 'brand:clicked'
            setActiveNav: (name) ->
                if name
                    navModel = _.find @collection.models, (model) ->
                        (model.get 'url') is name
                    if navModel
                        navModel.set 'status', 'active'
                    else
                        # unknow route

        )
    

