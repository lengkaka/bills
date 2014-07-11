define (require, exports, module) ->
    
    App = require 'module/application'
    
    App.module 'NavApp.List', (List, App) ->
        List.controller =
            listNavs: ->
                headersCollection = App.request 'header:entities'
                @headers = new List.Headers({collection: headersCollection})
                App.headerRegion.show @headers

            setActiveNav: (name) ->
                console.log "setActiveNav #{name}"
                @headers.setActiveNav name
        
