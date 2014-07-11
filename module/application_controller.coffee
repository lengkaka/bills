define (require, exports, module) ->
    homeView = require "views/home"
    appController = Marionette.Controller.extend
        notFound: ->
            console.log "notFound"
            myApp.trigger 'tables:list'

    module.exports = appController
