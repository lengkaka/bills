define (require, exports, module) ->

    App = require 'app/application'
    viewHelper = require 'view_helper'
    #handlebars = require 'handlebars'
    App.module 'TablesApp.content', (Content, App) ->
        Content.item = Marionette.ItemView.extend
            className: 'item'
            template: require 'templates/table/content/detail/detail_table_item.tpl'

        EmptyView = Marionette.ItemView.extend
            template: viewHelper.compile '<div id="empty">还没有items</div>'

        Content.listA = Marionette.CompositeView.extend
            className: 'table_list'
            template: require 'templates/table/content/detail/detail_table.tpl'
            itemView: Content.item
            itemViewContainer: 'div.list'
            emptyView: EmptyView

        Content.list = Marionette.CompositeView.extend
            className: 'table_list'
            template: require 'templates/table/content/detail/detail_table.tpl'
            headerTemplate: require 'templates/table/content/detail/detail_table_header.tpl'
            itemTemplate: require 'templates/table/content/detail/detail_table_item.tpl'
            emptyView: EmptyView
            events:
                'click #create_row': '_createRowAction'
                'click #filter_by_created_on': '_filterByDateAction'
            onRender: ()->
                @$('#set-date').datepicker({dateFormat: "yy-mm-dd", autoSize: true});
                @$table = @$el.find('table');
                if @options.itemCollection.length > 0
                    do @_renderItems
                    do @_hideEmptyView

                # bind search
                @searchInput = @$el.find('#search');
                @searchInput.bind 'keyup', (e)=>
                    console.log $(e.currentTarget).val()
                this

            _createRowAction: (e)->
                if @options.itemCollection.length is 0
                    do @_renderItems
                    do @_hideEmptyView
                do @$customTable.insertNewRow

            _filterByDateAction: (e)->
                date = $.trim($('#set-date').val())
                if !date or _.size(date) is 0
                    # tips set date
                    return
                console.log date

            _renderItems: ()->
                do @_renderHeaders
                do @_renderAllItems
                options =
                    add: ()->
                        console.log arguments
                    edit: ()->
                        console.log arguments
                    save: ($customTable, index, fields)=>
                        console.log arguments
                        index = @options.itemCollection.length - index - 1
                        editItemModel = @options.itemCollection.at index
                        if editItemModel
                            editItemModel.set 'fields', fields
                            @_updateItemToServer editItemModel
                        true
                    deleteRow: ($customTable, index)=>
                        console.log arguments
                        index = @options.itemCollection.length - index - 1
                        editItemModel = @options.itemCollection.at index
                        if editItemModel && editItemModel.mode isnt 'create'
                            @_removeItemToServer editItemModel
                        true
                    change: ()->
                        console.log arguments
                    selected: ()->
                        console.log arguments
                    insertRow: ()=>
                        newItemObj = @options.tableModel.getTableEmptyItem()
                        @options.itemCollection.add(newItemObj)
                        newItemModel = @options.itemCollection.at @options.itemCollection.length - 1
                        if newItemModel
                            newItemModel.mode = 'create'
                        return  @itemTemplate({values: newItemObj})

                @$customTable = @$table.customTable(options);

            _renderHeaders: ()->
                @$thead = @$table.find('thead')
                fields = @options.tableModel.getTableFields()
                @$thead.html(@headerTemplate({fields: fields}))

                do @_fixHeader

            _fixHeader: ()->
                tableOffset = @$table.offset().top
                $header = @$thead.clone()
                $fixedHeader = @$el.find("#header-fixed").append $header

                @$fixedHeaderTable = @$el.find(".table-items-detail-content-header")
                console.log @$fixedHeaderTable.position();
                @$container = @$el.find('.table-items-detail-content-main')
                console.log @$table.position();

                @$container.bind "scroll", ()=>
                    scrollLeft =  @$container.scrollLeft()
                    if scrollLeft isnt @$fixedHeaderTable.scrollLeft()
                        @$fixedHeaderTable.scrollLeft(scrollLeft)

                @$fixedHeaderTable.bind "scroll", ()=>
                    scrollLeft =  @$fixedHeaderTable.scrollLeft()
                    if scrollLeft isnt @$container.scrollLeft()
                        @$container.scrollLeft(scrollLeft)

            _renderAllItems: ()->
                @$tbody = @$table.find('tbody')
                length = @options.itemCollection.length
                _.each @options.itemCollection.models, (model, index)=>
                    modelObj = _.extend({index: length - index}, model.toJSON())
                    modelObj = @options.tableModel.getFullItem modelObj
                    @$tbody.prepend(@itemTemplate({values: modelObj}))

            _hideEmptyView: ()->
                @$el.find('#empty').hide();

            _showEmptyView: ()->
                @$el.find('#empty').hide();

            _removeItemToServer: (itemModel)->
                if itemModel
                    if itemModel.mode is 'create'
                        return true
                    url = "http://115.28.10.1:3000/tables/#{@options.tableId}"
                    url = "#{url}/item/delete"
                    data = _.pick itemModel.toJSON(), '_id'
                    WJ.ajax(
                        type: "POST",
                        url: url
                        dataType: 'json'
                        data: data
                        xhrFields:
                            'Access-Control-Allow-Origin': '*'
                    ).done((result, textStatus, request)=>
                        removed = result.data
                        if removed and removed.status is 200
                            @options.itemCollection.remove itemModel
                        false
                    ).fail((request, textStatus, errThrown)->
                        console.log "fail: " + textStatus
                        false
                    )
                false

            _updateItemToServer: (itemModel)->
                if itemModel
                    url = "http://115.28.10.1:3000/tables/#{@options.tableId}"
                    if itemModel.mode is 'create'
                        url = "#{url}/item/create"
                    else
                        url = "#{url}/item/update"
                    data = itemModel.toJSON()
                    WJ.ajax(
                        type: "POST",
                        url: url
                        dataType: 'json'
                        data: data
                        xhrFields:
                            'Access-Control-Allow-Origin': '*'
                    ).done((result, textStatus, request)->
                        item = result.data[0]
                        if itemModel.mode is 'create'
                            itemModel.set(item, {merge: true})
                            itemModel.mode = 'done'
                        false
                    ).fail((request, textStatus, errThrown)->
                        console.log "fail: " + textStatus
                        false
                    )
                false








