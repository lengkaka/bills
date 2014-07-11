define (require, exports, module) ->

    App = require 'app/application'
    viewHelper = require 'view_helper'
    itemModel = require 'model/item'

    App.module 'TablesApp.content', (Content, App) ->

        EmptyView = Marionette.ItemView.extend
            template: viewHelper.compile '<div id="empty">还没有items</div>'

        Content.itemView = Marionette.ItemView.extend
            tagName: 'tr'
            template: require 'templates/table/content/detail/detail_table_item.tpl'
            events:
                'click #item-edit': '_editAction'
                'click #item-save': '_saveAction'
                'click #item-delete': '_deleteAction'

            onRender: ->
                if this.options.model.get('mode') is 'create'
                    do @_enterEditStatus

            _editAction: (e)->
                console.log 'edit'
                do @_enterEditStatus

            _saveAction: (e)->
                console.log 'save'
                do @_outEditStatus
                # update data
                do @_updateItem

            _deleteAction: (e)->
                @trigger "do:remove", @index, @options.model

            _enterEditStatus: ()->
                tds = @$('td')
                $.each tds, (index, td)->
                    $td = $(td)
                    return if ($td.attr('id') is 'index' or $td.attr('id') is 'item-oper')

                    content = $td.html()
                    $container = $().add '<div class="table-items-detail-content-main-row-div"><input type="text" class="table-items-detail-content-main-row-div-row"></div>'
                    $input = $container.find 'input'
                    $input.val content
                    $td.html $container
                    isDate = if ($td.attr('field_type') is 'date') then true else false
                    if isDate
                        $input.css('width', '80%');
                        $input.datepicker({dateFormat: "yy-mm-dd"});
                        $container.append('<span class="glyphicon glyphicon-calendar"></span>');

                #update
                $replaceSelector = $().add('<span id="item-save" style="cursor: pointer;" class="glyphicon glyphicon-ok"></span>');
                @$('span.glyphicon-pencil').replaceWith($replaceSelector);

            _outEditStatus: (e)->
                tds = @$('td')
                $.each tds, (index, td)->
                    $td = $(td);
                    return if ($td.attr('id') is 'index' or $td.attr('id') is 'item-oper')
                    content = $td.find('input').val();
                    $td.html(content);
                $replaceSelector = $().add('<span id="item-edit" style="cursor: pointer;" class="glyphicon glyphicon-pencil"></span>');
                @$('span.glyphicon-ok').replaceWith($replaceSelector);

            _getStatus: ->
                if @status?
                    @status = 'view'
                return @status
            _isEditStatus: ->
                return @_getStatus() is 'edit'
            _updateStatus: (status)->
                @status = status

            _getELFieldsData: ->
                tds = @$('td')
                data = {}
                $.each tds, (index, td)->
                    $td = $(td);
                    return if ($td.attr('id') is 'index' or $td.attr('id') is 'item-oper')
                    field_id = $td.attr 'field_id'
                    content = $td.html()
                    data[field_id] = content
                data

            _updateItem: ->
                data = @_getELFieldsData()
                _.each this.options.model.get('fields'), (field)->
                    field.value = data[parseInt(field.id)]
                @_updateItemToServer(this.options.model)

            _updateItemToServer: (itemModel)->
                if itemModel
                    url = "http://115.28.10.1:3000/tables/#{@options.tableId}"
                    if itemModel.get('mode') is 'create'
                        url = "#{url}/item/create"
                    else
                        url = "#{url}/item/update"
                    data = itemModel.toJSON()
                    delete data['index']
                    delete data['mode']
                    WJ.ajax(
                        type: "POST",
                        url: url
                        dataType: 'json'
                        data: data
                        xhrFields:
                            'Access-Control-Allow-Origin': '*'
                    ).done((result, textStatus, request)->
                        item = result.data[0]
                        if itemModel.get('mode') is 'create'
                            itemModel.set(item, {merge: true})
                            itemModel.unset('mode')
                        false
                    ).fail((request, textStatus, errThrown)->
                        console.log "fail: " + textStatus
                        false
                    )
                false

            filterByKeyword: (keyword)->
                if _.size(keyword) is 0
                    do @$el.show
                else
                    match = _.find @options.model.get('fields'), (field)->
                        str = field.value.toString()
                        return str.indexOf(keyword) isnt -1
                    if match
                        do @$el.show
                    else
                        do @$el.hide

            updateIndex: (index)->
                @index = index
                @$('#index').html(index);

        Content.list = Marionette.CompositeView.extend
            className: 'table_list'
            template: require 'templates/table/content/detail/detail_table.tpl'
            headerTemplate: require 'templates/table/content/detail/detail_table_header.tpl'
            itemView: Content.itemView
            emptyView: EmptyView
            itemViewContainer: 'tbody'
            events:
                'click #create_row': '_createNewItemAction'
                'click #filter_by_created_on': '_filterByDateAction'
                'click #search_bt': '_filterByKeywordAction'

            itemViewOptions: (model, index)->
                length = @options.collection.length
                viewOptions =
                    index: length - index
                viewOptions

            buildItemView: (item, ItemViewType, itemViewOptions) ->
                options = _.extend {model: item}, itemViewOptions
                view = new ItemViewType(options);
                view

            onAfterItemAdded: (itemView)->
                index = _.indexOf @options.collection.models, itemView.options.model
                itemView.updateIndex itemView.options.index

            onItemRemoved: (itemView)->
                # if has no items，show empty
                if @options.collection.length is 0
                    do @_hideHeader
                else
                    do @_showHeader
                    do @_updateItemsIndex

            appendHtml: (compositeView, itemView, index)->
                if @options.collection.length is 0
                    @$el.append itemView.el
                else if compositeView.isBuffering
                    if compositeView.elBuffer.childElementCount is 0
                        compositeView.elBuffer.appendChild itemView.el
                    else
                        compositeView.elBuffer.insertBefore itemView.el, compositeView.elBuffer.firstChild
                else
                    $itemViewContainer = @getItemViewContainer compositeView
                    # 如果当前是空的，则需要渲染头部
                    $table = @$el.find('table#mainTable');
                    $thead = $table.find('thead')
                    if _.size($('thead').html()) is 0
                        do @_renderHeaders
                    $itemViewContainer.prepend itemView.el

            appendBuffer: (compositeView, buffer)->
                $itemViewContainer = @getItemViewContainer compositeView
                $itemViewContainer.append buffer

            initRenderBuffer: ->
                this.elBuffer = document.createDocumentFragment();

            onRender: ()->
                # bind date picker
                @$('#set-date').datepicker({dateFormat: "yy-mm-dd", autoSize: true});
                # bind search
                @searchInput = @$el.find('#search');
                @searchInput.bind 'keyup', (e)=>
                    console.log $(e.currentTarget).val()
                # if has collection render header
                if @options.collection.length > 0
                    do @_renderHeaders

                @on 'itemview:do:remove', @removeSingleItem
                this

            _filterByDateAction: (e)->
                date = $.trim(@$('#set-date').val())
                if !date or _.size(date) is 0
                    # tips set date
                    return
                # clear keyword
                @$('#search').val ''

                time = WJ.core.getFormatDateTime(date)
                filters =
                    created_on_from: time
                    created_on_to: time + 24 * 3600 * 1000
                WJ.dc.request 'collection/item', {tableId: @options.tableId, filters}, {mode: 'reset'}
                    .then ({entity: entityCollection, data: result})=>
                        WJ.log entityCollection
                        false
                    .then (params)->
                        # do error tips
                        false

            _createNewItemAction: (e)->
                newItemObj = @options.model.getTableEmptyItem()
                newItemObj.mode = 'create'
                @options.collection.add(newItemObj)
                do @_updateItemsIndex

            _updateItemsIndex: ->
                # update all item index
                length = @options.collection.length
                @children.each (itemView, index)->
                    itemView.updateIndex length - index

            _filterByKeywordAction: (e)->
                keyword = $.trim @$('#search').val()
                @children.each (itemView)->
                    itemView.filterByKeyword keyword

            removeSingleItem: (itemView, index, itemModel)->

                @$('#delete-dialog').modal()
                @$("#delete-dialog").on "shown.bs.modal", =>
                    @$("#delete-dialog #ok").on "click", (e)=>
                        @$("#delete-dialog").modal('hide');     # dismiss the dialog
                        @_removeItemModel itemModel

                false
            _removeItemModel: (itemModel)->
                if itemModel
                    if itemModel.get('mode') is 'create'
                        # 直接删除
                        @_removeItem itemModel
                    else
                        @_removeItemToServer itemModel

            _renderHeaders: ()->
                fields = @options.model.getTableFields()
                @$table = @$el.find('table#mainTable');
                @$thead = @$table.find('thead')
                @$thead.html(@headerTemplate({fields: fields}))
                # render fixHeader
                do @_fixHeader

            _fixHeader: ()->
                tableOffset = @$table.offset().top
                $header = @$thead.clone()
                $fixedHeader = @$el.find("#header-fixed").append $header

                @$fixedHeaderTable = @$el.find(".table-items-detail-content-header")
                @$container = @$el.find('.table-items-detail-content-main')

                @$container.bind "scroll", ()=>
                    scrollLeft =  @$container.scrollLeft()
                    if scrollLeft isnt @$fixedHeaderTable.scrollLeft()
                        @$fixedHeaderTable.scrollLeft(scrollLeft)

                @$fixedHeaderTable.bind "scroll", ()=>
                    scrollLeft =  @$fixedHeaderTable.scrollLeft()
                    if scrollLeft isnt @$container.scrollLeft()
                        @$container.scrollLeft(scrollLeft)
            _hideHeader: ->
                $table = @$el.find('table#mainTable');
                $thead = $table.find('thead')
                $thead.hide()
                $fixedHeader = @$el.find("#header-fixed")
                $fixedHeader.hide()

            _showHeader: ->
                $table = @$el.find('table#mainTable');
                $thead = $table.find('thead')
                $thead.show()
                $fixedHeader = @$el.find("#header-fixed")
                $fixedHeader.show()

            _removeItem: (itemModel)->
                if itemModel
                    @options.collection.remove itemModel

            _removeItemToServer: (itemModel)->
                if itemModel
                    if itemModel.mode is 'create'
                        return true
                    url = "http://115.28.10.1:3000/tables/#{@options.tableId}"
                    url = "#{url}/item/delete"
                    data = _.pick itemModel.toJSON(), '_id'
                    WJ.ajax
                        type: "POST",
                        url: url
                        dataType: 'json'
                        data: data
                        xhrFields:
                            'Access-Control-Allow-Origin': '*'
                    .done (result, textStatus, request)=>
                        removed = result.data
                        if removed and removed.status is 200
                            @_removeItem itemModel
                        false
                    .fail (request, textStatus, errThrown)->
                        console.log "fail: " + textStatus
                        false
                false
