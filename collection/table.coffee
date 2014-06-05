define (require, exports, module) ->
    tableModel = require 'model/table'
    table = Backbone.Collection.extend(
        id: 'id'
        model: tableModel
        url: '/tables/list'
        setSidebarActiveStatus: (tableId, status) ->
            if !(_.isUndefined tableId) and tableId
                model = @.get tableId
                if !(_.isUndefined model) and model
                    model.set 'active', status

    )

    module.exports = table
