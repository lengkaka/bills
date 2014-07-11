define (require, exports, module)->

    App = require 'app/application'

    App.module 'TablesApp.content', (Content, App)->
        Content.statisticsView = Marionette.ItemView.extend
            tagName: 'div'
            template: require 'templates/table/content/detail/detail_table_statistics.tpl'