define (require, exports, module) ->
    itemModel = require 'model/item'
    item = Backbone.Collection.extend(
        id: 'id'
        model: itemModel
        url: '/tables/items'

        getItemsArray: ()->
            return _.cloneDeep this.models.toJSON()
    )

    module.exports = item
