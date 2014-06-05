define (require, exports, module) ->
    
    App = require 'app/application'
    require 'app/header/list/list_controller'
    require 'app/header/list/list_view'
    
    App.module 'NavApp', (Nav, App) ->
        API =
            listNavs: () ->
                do Nav.List.controller.listNavs

            setActiveNav: (name) ->
                Nav.List.controller.setActiveNav name
                

        App.commands.setHandler 'set:Nav', (name) ->
            App.NavApp.List.controller.setActiveNav name

        Nav.on 'start', () ->
            console.log 'nav_app start'
            do API.listNavs
            
