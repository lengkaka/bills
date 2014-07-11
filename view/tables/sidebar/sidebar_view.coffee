define (require, exports, module) ->
    App = require 'module/application'
    TableSidebar = require 'templates/table/sidebar/table_sidebar.tpl'
    TableSidebarItem = require 'templates/table/sidebar/table_sidebar_item.tpl'
    App.module 'TablesApp.Sidebar', (Sidebar, App) ->
        Sidebar.Item = Marionette.ItemView.extend
            template: TableSidebarItem
            tagName: 'li'
            modelEvents:
                'change': 'onRender'

            onRender: ()->
                @$el.attr 'wj_table_id', (@model.get 'id')
                if @model.get 'active'
                    @$el.addClass 'active'
                else
                    @$el.removeClass 'active'

        Sidebar.List = Marionette.CompositeView.extend
            className: 'col-sm-3 sidebar container-sidebar'
            template: TableSidebar
            itemView: Sidebar.Item
            itemViewContainer: "ul#tables"

            events:
                'click li[wj_table_id]': '_selectTableAction'
                'click li[wj_table_create]': '_createTableAction'
            onBeforeRender: () ->
                if App.router.action is 'tables:createTable'

                else
                    @collection.setSidebarActiveStatus App.params.tableId, true
                    @curTableId = App.params.tableId

            onRender: () ->
                if App.router.action is 'tables:createTable'
                    @$('li[wj_table_create]').addClass 'active'

            _selectTableAction: (e)->
                e.preventDefault()
                tableId = $(e.currentTarget).attr('wj_table_id')
                @_changeToTable tableId

            _changeToTable: (tableId)->
                tableId = parseInt tableId
                if tableId and @curTableId isnt tableId
                    @collection.setSidebarActiveStatus @curTableId, false
                    @collection.setSidebarActiveStatus tableId, true
                    @curTableId = tableId
                    App.navigate "/tables/#{@curTableId}"

                    # tell table_content module to display
                    App.commands.execute 'showTable', tableId,  @collection.get(tableId)
                    # create table lost focuse
                    @$('[wj_table_create]').removeClass 'active'

            _createTableAction: (e)->
                if @curTableId
                    @collection.setSidebarActiveStatus @curTableId, false
                    @curTableId = null
                $(e.currentTarget).addClass('active')
                # tell table_content module to display
                App.commands.execute 'createTable'
                App.navigate "/tables/create"
                false
