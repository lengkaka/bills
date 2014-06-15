define (require, exports, module) ->
    table = Backbone.Model.extend(
        getTableFields: ()->
            fields = this.get('fields')
            return fields

        getTableEmptyItem: ()->
            item = {}
            item.fields = []
            item.table_id = this.get 'id'
            fields = this.get('fields')
            _.each fields, (fieldObj)->
                field = {}
                field.id = fieldObj.id
                field.name = fieldObj.name
                field.value = ''
                item.fields.push field
            return item
    )

    module.exports = table

