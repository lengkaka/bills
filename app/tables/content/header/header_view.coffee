define (require, exports, module) ->
    App = require 'app/application'
    App.module 'TablesApp.content.header', (Header, App) ->
        Header.item = Marionette.ItemView.extend
            tagName: 'li'
            template: require 'templates/table/content/header/list_item.tpl'
            modelEvents:
                'change': 'onRender'
            onRender: ()->
                this.$el.attr 'table_header_id', (@model.get 'id')
                if @model.get 'active'
                    @$el.addClass 'active'
                else
                    @$el.removeClass 'active'

        Header.list = Marionette.CompositeView.extend
            className: 'header_list'
            template: require 'templates/table/content/header/list.tpl'
            itemView: Header.item
            itemViewContainer: 'ul'
            events:
                'click li': '_selectHeaderAction'

            onBeforeRender: ()->
                @updateActiveType @options.type

            _selectHeaderAction: (e)->
                $target = $(e.currentTarget)
                headerId = parseInt $target.attr('table_header_id')
                @_updateCurrentHeader headerId
                false

            updateActiveType: (type)->
                if type is 'view'
                    headerId = '1'
                else if type is 'statistics'
                    headerId = '2'
                else if type is 'edit'
                    headerId = '3'
                else if type is 'delete'
                    headerId = '4'
                @_setActiveType headerId
                @options.type = type

            _setActiveType: (headerId)->
                false if headerId?
                null if headerId is @headerId

                @collection.setActiveStatus @headerId, false
                @headerId = headerId
                @collection.setActiveStatus @headerId, true

            _updateCurrentHeader: (headerId)->
                # update collection
                @_setActiveType(headerId)

                # update url
                url = "/tables/#{@options.tableId}"
                type = @collection.get(@headerId).get('type');
                if type is 'view'
                    App.navigate url
                else if type is 'statistics'
                    App.navigate "#{url}/statistics"
                else if type is 'edit'
                    App.navigate "#{url}/edit"
                else if type is 'delete'
                    App.navigate "#{url}/delete"

                # tell content to show
                App.commands.execute 'showTableContent', @options.tableId, @options.tableModel, type
                false
