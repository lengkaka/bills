define (require, exports, module) ->
    appController = Marionette.Controller.extend
        notFound: ->
            console.log "notFound"
            myApp.trigger 'tables:list'

    module.exports = appController
