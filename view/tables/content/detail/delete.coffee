define (require, exports, module) ->

    App = require 'app/application'
    App.module 'TablesApp.content', (Content, App) ->
        Content.deleteView = Marionette.ItemView.extend
            className: 'jumbotron delete_table'
            template: require 'templates/table/content/detail/delete_table.tpl'
            events:
                'click #delete': '_deleteAction'

            _deleteAction: (e)->
                WJ.log "delete #{@options.tableId}"
                table_id = @options.tableModel.get('_id');
                url = "http://115.28.10.1:3000/tables/#{@options.tableId}/delete"
                WJ.ajax(
                    type: "POST",
                    url: url
                    dataType: 'json'
                    data: {_id: table_id}
                    xhrFields:
                        'Access-Control-Allow-Origin': '*'
                ).done((result, textStatus, request)=>
                    # delete local table model
                    tableCollection = WJ.core.getCollection 'table'
                    tableCollection.remove @options.tableId
                    if tableCollection.length is 0
                        url = "/tables/create"
                    else
                        firstTableId = tableCollection.at(0).get('id');
                        url = "/tables/#{firstTableId}"
                    _.delay ()->
                        App.navigate url, {trigger:true}
                    , 500
                    false
                ).fail((request, textStatus, errThrown)->
                    console.log "fail: " + textStatus
                    false
                )
                false


