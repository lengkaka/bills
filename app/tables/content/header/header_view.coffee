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
                if @options.type is 'view'
                    headerId = '1'
                else if @options.type is 'edit'
                    headerId = '2'
                else if @options.type is 'delete'
                    headerId = '3'
                @_updateCurrentHeader headerId

            _selectHeaderAction: (e)->
                $target = $(e.currentTarget)
                headerId = parseInt $target.attr('table_header_id')
                @_updateCurrentHeader headerId
                # tell the table content to show
                false

            _updateCurrentHeader: (headerId)->
                false if headerId?
                null if headerId is @headerId

                @collection.setActiveStatus @headerId, false
                @headerId = headerId
                @collection.setActiveStatus @headerId, true

                url = "/tables/#{@options.tableId}"
                type = @collection.get(@headerId).get('type');
                if type is 'view'
                    App.navigate url
                else if type is 'edit'
                    App.navigate "#{url}/edit"
                else if type is 'delete'
                    App.navigate "#{url}/delete"

                # tell content to show
                App.commands.execute 'showTableContent', @options.tableId, @options.tableModel, type
                false

            onRender: ->
                # make sure nav active
                console.log '111'

