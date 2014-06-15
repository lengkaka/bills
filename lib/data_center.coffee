define (require, exports, module) ->

    RSVP = require 'rsvp'
    baseUrl = 'http://115.28.10.1:3000'
    DataCenter = Backbone.Wreqr.RequestResponse.extend

        models:
            table: require 'model/table'
            item: require 'model/item'
        collections:
            table: require 'collection/table'
            item: require 'collection/item'

        _cache: new Backbone.Model

        initialize: (options = {}) ->
            _.each {model: @models, collection: @collections}, (entities, type) ->
                _.each entities, (Entity, name) ->
                    unless Entity::customRequestHandler
                        @setHandler "#{type}/#{name}", _.bind(_.partial(@_requestHandler, Entity, type, name), this)
                        if type == 'collection'
                            @setHandler "#{type}/#{name}:more", _.bind(_.partial(@_requestMoreHandler, Entity, type, name), this)
                            @setHandler "#{type}/#{name}:reload", _.bind(_.partial(@_requestReloadHandler, Entity, type, name), this)
                            @setHandler "#{type}/#{name}:reset", _.bind(_.partial(@_requestResetHandler, Entity, type, name), this)
                , this
            , this

        # Public: 批量获取实体(model/collection)
        #
        # requests - 请求的参数列表
        # options  - 控制参数
        #
        # Examples
        #
        #   HB.dc.batchRequest [
        #       'model/user'
        #       'collection/company' # 省略params和options的形式
        #       ['model/contact', {userId: 10000}]
        #       ['collection/notification', {viewed: 'unviewed'}]
        #   ]
        #   .then (result) ->
        #       console.log result
        #
        #   等价于
        #
        #   p1 = HB.dc.request 'model/user'
        #   p2 = HB.dc.request 'collection/company'
        #   p3 = HB.dc.request 'model/contact', userId: 10000
        #   p4 = HB.dc.request 'collection/notification', viewed: 'unviewed'
        #
        #   RSVP.all [p1, p2, p3, p4]
        #   .then (result) ->
        #       console.log result
        #
        # 返回一个promise
        batchRequest: (requests, options = {}) ->
            if _.isString requests
                requests = [requests]
            promises = _.map requests, (request) ->
                if _.isString request
                    request = [request]
                else if _.isArray request
                    request[2] = _.extend({}, options, request[2])
                else
                    throw message: "unrecognized request", request: request
                @request.apply this, request
            , this
            RSVP.all promises

        _requestMoreHandler: (Entity, type, name, params, options = {}) ->
            options = _.extend options, {mode: 'more'}
            @_requestHandler(Entity, type, name, params, options)

        _requestReloadHandler: (Entity, type, name, params, options = {}) ->
            options = _.extend options, {mode: 'reload'}
            @_requestHandler(Entity, type, name, params, options)

        _requestResetHandler: (Entity, type, name, params, options = {}) ->
            options = _.extend options, {mode: 'reset'}
            @_requestHandler(Entity, type, name, params, options)

        # Private: 通过model和collection处理请求
        #          通过promise异步返回数据
        #
        # entity        - 实体类
        # type          - 实体类型 model/collection
        # name          - 实体名称
        # params        - 请求参数
        # userOptions   - 参数
        #               :cache - true/false 是否使用缓存数据，默认为true
        #                        还可以通过在entity中设置cacheDisabled = true 属性来控制该值为false
        #               :fetch - true/false 是否需要发起ajax请求数据，默认为true
        #               :mode  - default/more/reload/reset collection的处理模式，默认为default
        #                        default - 获取列表前30个，覆盖到collection
        #                        more    - 根据当前collection内model个数，获取后面的30个，追加进collection
        #                        reload  - 重载当前collection内的所有model
        #                        reset   - 获取列表前30个，重置当前的collection
        #               :limit - collection每分页model个数
        #
        # 返回一个promise
        _requestHandler: (Entity, type, name, params = {}, userOptions = {})->
            key = @_getKey Entity, type, name, params
            mode = userOptions.mode or 'default'
            cache = if mode isnt 'default' or Entity::cacheDisabled then false else true
            defaultOptions = {cache: cache, fetch: true, mode: mode, limit: 30}
            options = _.extend defaultOptions, userOptions

            cached = @_cache.has key
            if cached
                entity = @_cache.get key
            else
                entity = new Entity
                entity.status = @entityStatus.NOT_READY
                @_cache.set key, entity

            promiseKey = '_promise'
            if type is 'collection'
                switch options.mode
                    when 'more'
                        params.offset = params.offset or entity.length
                        params.limit = params.limit or options.limit
                    when 'reload'
                        params.offset = 0
                        params.limit = entity.length or options.limit
                    else
                        params.offset = 0
                        params.limit = options.limit
                promiseKey = "#{promiseKey}_o#{params.offset}_l#{params.limit}"
            return entity[promiseKey] if entity[promiseKey]

            promise = new RSVP.Promise (resolve, reject) =>
                if cached and options.cache
                    resolve entity: entity, cache: true
                    return unless options.fetch
                @_fetchEntity entity, params
                    .then (data) ->
                        delete entity[promiseKey]
                        data
                    .then (data) =>
                        #target = data["#{type}s"][name]
                        target = data
                        result = @_getResult entity, type, target
                        if result.errorCode
                            @_cache.unset key unless cached
                            return reject code: result.errorCode, message: result.errorMessage
                        else if options.mode is 'more'
                            entity.add result
                        else if options.mode is 'reset'
                            entity.reset result
                        else
                            entity.set result
                        entity.status = @entityStatus.READY
                        resolve entity: entity, data: result, cache: false
                        null
                    .then null, =>
                        delete entity[promiseKey]
                        @_cache.unset key unless cached
                        do reject
                    null
            entity[promiseKey] = promise if options.fetch
            promise

        # Private: 根据参数获取标识实体的唯一键
        #
        # Entity  - 实体类
        # type    - 类型 model/collection
        # name    - 名称
        # params  - 其他参数
        #
        # 返回键的字符串
        _getKey: (Entity, type, name, params = {}) ->
            ret = "#{type}:#{name}"
            if _.has Entity.prototype, 'apiParams'
                ret = _.foldl Entity::apiParams, (result, key) ->
                    if _.has params, key
                        result = "#{result}:#{key}_#{params[key]}"
                    else
                        throw "请求 #{type}/#{name} 时缺少参数：#{key}"
                    result
                , ret
            ret

        # Private: 发起ajax请求获取实体数据
        #
        # entity - 实体对象 model/collection
        # parmas - 请求参数
        #
        # 返回一个promise
        _fetchEntity: (entity, params) ->
            data = _.extend {}, params
            unless entity.url?.length
                throw "未定义数据接口"
                return
            url = entity.url.replace /\{\{(\w+)\}\}/g, (placeholder, key) ->
                value = data[key]
                delete data[key]
                value
            entity.status = @entityStatus.PROCESSING
            RSVP.Promise.resolve(WJ.ajax baseUrl + url, type: "GET", dataType: 'json', data: data, xhrFields:{'Access-Control-Allow-Origin': '*'})

        # Private: 整理服务器返回数据
        #
        # type - 实体类型
        # data - 服务器返回数据
        #
        # 返回实体的数据
        _getResult: (entity, type, data) ->
            if data.errorCode
                return data

            if _.isFunction entity.format
                result = entity.format data.data
                #result = entity.format data
            else
                result = data.data
                #result = data

        getCollection: (name, params = {}, userOptions = {})->

            type = 'collection'
            Entity = @collections[name]
            if Entity
                key = @_getKey Entity, type, name, params
                cached = @_cache.has key
                if cached
                    entity = @_cache.get key
                else
                    entity = new Entity
                    entity.status = @entityStatus.NOT_READY
                    @_cache.set key, entity

                return entity
            null

        entityStatus:
            NOT_READY: 10000
            PROCESSING: 10001
            READY: 10002

    module.exports = DataCenter
