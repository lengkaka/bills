define (require, exports, module) ->
    itemModel = require 'model/item'
    item = Backbone.Collection.extend(
        id: 'id'
        model: itemModel
        url: '/tables/:tableId/items'
        apiParams: ['tableId']
        getItemsArray: ()->
            return _.cloneDeep this.models.toJSON()
    )

    module.exports = item
