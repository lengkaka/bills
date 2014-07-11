define (require, exprots, module) ->
    App = require 'app/application'
    App.module 'TablesApp.content', (Content, App) ->
        layout = require 'templates/table/content/content_layout.tpl'
        Content.Layout = Marionette.Layout.extend
            className: 'content_layout'
            template: layout
            regions:
                header: '#content_region_header'
                detail: '#content_region_detail'

            onRender: ->
                # 根据action来确定操作
                tableAction = App.router.action
              #  if tableAction is 'listTables'

              #  else if tableAction is 'showTables'

              #  else if tableAction is 'editTable'

                console.log App.params
                console.log App.router
