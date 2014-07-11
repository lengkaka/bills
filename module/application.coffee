define (require, exports, module) ->
    # app_router
    router = require('module/application_router')
    # app_controller
    appController = require('module/application_controller')

    app = new Marionette.Application()
    
    app.router =
    
    app.params =

    app.addRegions
        headerRegion: '#header-region'
        mainRegion: '#main-region'

    app.navigate = (route, options) ->
        options = options || {}
        Backbone.history.navigate route, options

    app.getCurrentRoute = () ->
        return Backbone.history.fragment

    app.addInitializer ->
        @.router = new router({controller : new appController()})
        null

    app.on 'initialize:before', (options)->
        console.log "initialize:before"

    app.on 'initialize:after', (options)->
        if Backbone.history
            Backbone.history.start()

        console.log 'initialize:after'
    
    app.on 'start', (options) ->
        console.log 'start'

    module.exports = app

