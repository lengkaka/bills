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
                field.type = fieldObj.type
                field.value = ''
                item.fields.push field
            item.created_on = WJ.core.getFormatDateTime()
            return item

        getFullItem: (itemObj)->
            if itemObj
                fields = this.get('fields')
                fields = _.cloneDeep fields
                _.each fields, (fieldObj)->
                    itemField = _.find itemObj.fields, (field) ->
                        return field.id + '' is fieldObj.id + ''
                    fieldObj.value = ''
                    if itemField
                        fieldObj.value = itemField.value
                itemObj.fields = fields

            return itemObj
    )

    module.exports = table

