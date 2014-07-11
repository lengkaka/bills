define (require, exports, module) ->
    App = require 'app/application'
    require 'app/tables/tables_layout'
    require 'app/tables/sidebar/sidebar_view'
    require 'app/tables/content/content_layout'
    require 'app/tables/content/content_app'
    LoadingView = require 'app/loading_view'

    App.module 'TablesApp', (Tables, App) ->
        Tables.Router = Marionette.AppRouter.extend
            appRoutes:
                'tables': 'listTables'
                'tables/create': 'createTable'
                'tables/:id': 'showTable'
                'tables/:id/statistics': 'statisticsTable'
                'tables/:id/edit': 'editTable'
                'tables/:id/delete': 'deleteTable'

            onRoute: (name, path, args) ->
                console.log("tables_onRoute fired")
                console.log(name, path, args)
                # tell nav switch to tablse
                App.execute 'set:Nav', 'tables'

        API =
            showTableLayoutAndNav: (action, tableId)->
                # show loading
                loadingView = new LoadingView();
                App.mainRegion.show loadingView

                # show tables
                WJ.dc.request 'collection/table'
                    .then ({entity: entityCollection, data: result})=>
                        API.showTables entityCollection, action, tableId
                        false
                    .then (params)->
                        # do error tips
                        false
                false

            showTables: (entityCollection, action, tableId)->
                # show tables in sidebar
                Tables.layout = new Tables.Layout()
                App.mainRegion.show Tables.layout

                table_sidebar = new Tables.Sidebar.List({collection: entityCollection})
                Tables.layout.sidebar.show table_sidebar

                # if no tables, navigate to create table
                if entityCollection.length is 0
                    App.navigate '/tables/create', {trigger: true}
                    null

                # if no special tableId, navigate to the first table
                if action is 'listTables'
                    firstTable = entityCollection.at 0
                    App.navigate "/tables/#{firstTable.get('id')}", {trigger: true}
                    null

                if action is 'showTable'
                    App.commands.execute 'showTable', tableId, entityCollection.get(tableId)
                else if action is 'statisticsTable'
                    App.commands.execute 'statisticsTable', tableId, entityCollection.get(tableId)
                else if action is 'editTable'
                    App.commands.execute 'editTable', tableId, entityCollection.get(tableId)
                else if action is 'deleteTable'
                    App.commands.execute 'deleteTable', tableId, entityCollection.get(tableId)
                else if action is 'createTable'
                    App.commands.execute 'createTable'

            # show all tables
            listTables: () ->
                App.router.action = 'tables:listTables'
                @showTableLayoutAndNav 'listTables'

            # show special table and support curd operations
            showTable: (tableId) ->
                App.router.action = 'tables:showTable'
                App.params.tableId = tableId
                @showTableLayoutAndNav 'showTable', tableId

            statisticsTable: (tableId)->
                App.router.action = 'tables:statisticsTable'
                App.params.tableId = tableId
                @showTableLayoutAndNav 'statisticsTable', tableId

            # edit table
            editTable: (tableId) ->
                App.router.action = 'tables:editTable'
                App.params.tableId = tableId
                @showTableLayoutAndNav 'editTable', tableId

            # edit table
            deleteTable: (tableId) ->
                App.router.action = 'tables:deleteTable'
                App.params.tableId = tableId
                @showTableLayoutAndNav 'deleteTable', tableId

            # create table
            createTable: () ->
                App.router.action = 'tables:createTable'
                @showTableLayoutAndNav 'createTable'

        App.on 'tables:list', () ->
            do API.listTables

        App.addInitializer ()->
            new Tables.Router({controller: API})
