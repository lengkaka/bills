define (require, exports, module) ->
    App = require 'module/application'
    App.module 'Entities.tables', (tables, App) ->

        # sidebar
        tables.sidebarModel = Backbone.Model.extend()
        tables.sidebarCollection = Backbone.Collection.extend(
            id: 'id'
            model: tables.sidebarModel
            setSidebarActiveStatus: (tableId, status) ->
                if !(_.isUndefined tableId) and tableId
                    model = @.get tableId
                    if !(_.isUndefined model) and model
                        model.set 'active', status

        )
        # content
        tables.contentHeaderModel = Backbone.Model.extend()
        tables.contentHeaderCollection = Backbone.Collection.extend(
            id: 'id'
            model: tables.contentHeaderModel
            setActiveStatus: (id, status) ->
                if !(_.isUndefined id) and id
                    model = @.get id
                    if !(_.isUndefined model) and model
                        model.set 'active', status
        )
        tables.contentCreateFieldModel = Backbone.Model.extend()
        tables.contentCreateFieldCollection = Backbone.Collection.extend(
            id: 'id'
            model: tables.contentCreateFieldModel
        )

        API =
            getSidebar: ()->
                tables.sidebarCollections = new tables.sidebarCollection([
                    {id:1, name: '销售'},
                    {id:2, name: '合同'},
                    {id:3, name: '订单'}
                ])
            getContentHeaders: ()->
                tables.contentHeaders = new tables.contentHeaderCollection([
                    {id:1, name: '浏览', type: 'view'},
                    {id:2, name: '统计', type: 'statistics'},
                    {id:3, name: '编辑', type: 'edit'},
                    {id:4, name: '删除', type: 'delete'}
                ])
            # create or edit
            getContentCreateFields: (fieldsArray)->
                if fieldsArray and _.isArray(fieldsArray)
                    contentCreateFields = new tables.contentCreateFieldCollection(fieldsArray)
                else
                    contentCreateFields = new tables.contentCreateFieldCollection([
                        {id: 1, name: '第一个字段', type: 1}
                    ])

        App.reqres.setHandler 'tables:sidebar', () ->
            do API.getSidebar
        App.reqres.setHandler 'tables:content:headers', () ->
            do API.getContentHeaders
        App.reqres.setHandler 'tables:content:createTable', (fieldsArray) ->
            API.getContentCreateFields fieldsArray
