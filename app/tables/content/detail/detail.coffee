define (require, exports, module) ->

    App = require 'app/application'
    App.module 'TablesApp.content', (Content, App) ->
        Content.item = Marionette.ItemView.extend
            className: 'item'
            template: require 'templates/table/content/detail/detail_table_item.tpl'

        Content.list = Marionette.CompositeView.extend
            className: 'table_list'
            template: require 'templates/table/content/detail/detail_table.tpl'
            itemView: Content.item
            itemViewContainer: 'div.list'

