define (require, exports, module) ->

    App = require 'app/application'
    require 'app/tables/content/content_layout'
    require 'app/tables/content/header/header_view'
    require 'app/tables/content/detail/create'
    require 'app/tables/content/detail/detail'
    require 'app/tables/content/detail/delete'

    LoadingView = require 'app/loading_view'
    App.module 'TablesApp.content', (Content, App) ->
        Content.controller =

            _showloading: ()->
                loadingView = new LoadingView();
                App.TablesApp.layout.content.show loadingView

            _showLayout: ()->
                # 显示table content 部分
                Content.layout = new Content.Layout()
                App.TablesApp.layout.content.show Content.layout

            _showTableHeader: (tableId, tableModel, type)->
                headerItems = App.request 'tables:content:headers'
                headerListView = new Content.header.list({collection: headerItems, tableId: tableId, tableModel: tableModel, type: type})
                Content.layout.header.show headerListView

            ##
            # showTableContent
            # 展示表格内容部分
            #
            # tableId
            # tableModel
            # type， view、edit、delete
            ##
            showTableContent: (tableId, tableModel, type)->
                if type is 'edit'
                    fields = App.request 'tables:content:createTable', tableModel.get('fields')
                    createView = new Content.createView({model:tableModel, collection: fields, mode: 'edit'})
                    Content.layout.detail.show createView
                else if type is 'delete'
                    # show delete
                    deleteView = new Content.deleteView({tableId: tableId, tableModel: tableModel})
                    Content.layout.detail.show deleteView
                else
                    # show items
                    listView = new Content.list()
                    Content.layout.detail.show listView

            showTable: (tableId, tableModel)->
                do @_showLayout
                @_showTableHeader tableId, tableModel, 'view'

            editTable: (tableId, tableModel)->
                do @_showLayout
                @_showTableHeader tableId, tableModel, 'edit'
                @showTableContent tableId, tableModel, 'edit'

            deleteTable: (tableId, tableModel)->
                do @_showLayout
                @_showTableHeader tableId, tableModel, 'delete'
                @showTableContent tableId, tableModel, 'delete'

            createTable: ->
                do @_showLayout
                fields = App.request 'tables:content:createTable'
                createView = new Content.createView({collection: fields})
                Content.layout.detail.show createView

        # 接收通知
        App.commands.setHandler 'showTableContent', (tableId, tableModel, type)->
            Content.controller.showTableContent tableId, tableModel, type

        App.commands.setHandler 'showTable', (tableId, tableModel)->
            Content.controller.showTable tableId, tableModel
        App.commands.setHandler 'editTable', (tableId, tableModel)->
            Content.controller.editTable tableId, tableModel
        App.commands.setHandler 'deleteTable', (tableId, tableModel)->
            Content.controller.deleteTable tableId, tableModel
        App.commands.setHandler 'createTable', ->
            do Content.controller.createTable
