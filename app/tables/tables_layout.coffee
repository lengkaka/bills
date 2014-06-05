define (require, exports, module) ->
    App = require 'app/application'
    App.module 'TablesApp', (Tables, App) ->
        layout = require 'templates/table/table_layout.tpl'
        Tables.Layout = Marionette.Layout.extend(
            className: 'table_layout'
            template: layout
            regions:
                sidebar: '#table_region_sidebar'
                content: '#table_region_content'
        )
            
