define (require, exports, module) ->
    App = require 'module/application'
    App.module 'TablesApp.content', (Content, App) ->
        Content.createItem = Marionette.ItemView.extend
            className: 'row field'
            template: require 'templates/table/content/detail/create_table_field.tpl'
            onRender: ->
                @$el.attr 'wj_field_id', this.model.get('id')

        Content.createView = Marionette.CompositeView.extend
            className: 'create_view'
            template: require 'templates/table/content/detail/create_table.tpl'
            itemView: Content.createItem
            itemViewContainer: 'div.table_fields'
            events:
                'click .add_field': '_addFieldAction'
                'click .delete_field': '_deleteFieldAction'
                'click [wj_submit_create_table]': '_submitAction'

            _addFieldAction: (e)->
                if _.isUndefined @fieldIndex
                    @fieldIndex = @collection.length + 1
                else
                    @fieldIndex++
                @collection.add {id:@fieldIndex, name:'', type:''}

            _deleteFieldAction: (e)->
                $item = $(e.currentTarget)
                if @collection.length is 1
                    return
                fieldId = $item.attr 'wj_remove_field_id'
                @collection.remove fieldId

            _submitAction: (e)->
                # check submit content
                formData = form2js 'create_table_form', '.', true, null
                # processFormData
                @_processFormData formData
                # submit data
                @_crossDomainSubmit formData
                false

            _processFormData: (data)->
                if data
                    fields = data.fields
                    typeChina2Pinyin =
                        '字符串': 'string'
                        '数字': 'number'
                        '日期': 'date'
                    if fields
                        _.each fields, (field)->
                            field.type = typeChina2Pinyin[field.type]

                return data

            _crossDomainSubmit: (data)->

                url = 'http://115.28.10.1:3000'
                if @options.mode is 'edit'
                    url = "#{url}/tables/#{data.id}/update"
                else
                    url = "#{url}/tables/create"

                WJ.ajax(
                    type: "POST",
                    url: url
                    dataType: 'json'
                    data: data
                    xhrFields:
                        'Access-Control-Allow-Origin': '*'
                ).done((result, textStatus, request)->
                    newTable = result.data[0]
                    tableCollection = WJ.core.getCollection 'table'
                    tableCollection.add newTable, {merge: true}
                    url = "/tables/#{newTable.id}"
                    _.delay ()->
                        App.navigate url, {trigger:true}
                    , 500
                    console.log "Data Saved: " + newTable
                    false
                ).fail((request, textStatus, errThrown)->
                    console.log "fail: " + textStatus
                    false
                )
                false
