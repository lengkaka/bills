// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var DataCenter, RSVP, baseUrl;
    RSVP = require('rsvp');
    baseUrl = 'http://115.28.10.1:3000';
    DataCenter = Backbone.Wreqr.RequestResponse.extend({
      models: {
        table: require('model/table'),
        item: require('model/item')
      },
      collections: {
        table: require('collection/table'),
        item: require('collection/item')
      },
      _cache: new Backbone.Model,
      initialize: function(options) {
        if (options == null) {
          options = {};
        }
        return _.each({
          model: this.models,
          collection: this.collections
        }, function(entities, type) {
          return _.each(entities, function(Entity, name) {
            if (!Entity.prototype.customRequestHandler) {
              this.setHandler("" + type + "/" + name, _.bind(_.partial(this._requestHandler, Entity, type, name), this));
              if (type === 'collection') {
                this.setHandler("" + type + "/" + name + ":more", _.bind(_.partial(this._requestMoreHandler, Entity, type, name), this));
                this.setHandler("" + type + "/" + name + ":reload", _.bind(_.partial(this._requestReloadHandler, Entity, type, name), this));
                return this.setHandler("" + type + "/" + name + ":reset", _.bind(_.partial(this._requestResetHandler, Entity, type, name), this));
              }
            }
          }, this);
        }, this);
      },
      batchRequest: function(requests, options) {
        var promises;
        if (options == null) {
          options = {};
        }
        if (_.isString(requests)) {
          requests = [requests];
        }
        promises = _.map(requests, function(request) {
          if (_.isString(request)) {
            request = [request];
          } else if (_.isArray(request)) {
            request[2] = _.extend({}, options, request[2]);
          } else {
            throw {
              message: "unrecognized request",
              request: request
            };
          }
          return this.request.apply(this, request);
        }, this);
        return RSVP.all(promises);
      },
      _requestMoreHandler: function(Entity, type, name, params, options) {
        if (options == null) {
          options = {};
        }
        options = _.extend(options, {
          mode: 'more'
        });
        return this._requestHandler(Entity, type, name, params, options);
      },
      _requestReloadHandler: function(Entity, type, name, params, options) {
        if (options == null) {
          options = {};
        }
        options = _.extend(options, {
          mode: 'reload'
        });
        return this._requestHandler(Entity, type, name, params, options);
      },
      _requestResetHandler: function(Entity, type, name, params, options) {
        if (options == null) {
          options = {};
        }
        options = _.extend(options, {
          mode: 'reset'
        });
        return this._requestHandler(Entity, type, name, params, options);
      },
      _requestHandler: function(Entity, type, name, params, userOptions) {
        var cache, cached, defaultOptions, entity, key, mode, options, promise, promiseKey;
        if (params == null) {
          params = {};
        }
        if (userOptions == null) {
          userOptions = {};
        }
        key = this._getKey(Entity, type, name, params);
        mode = userOptions.mode || 'default';
        cache = mode !== 'default' || Entity.prototype.cacheDisabled ? false : true;
        defaultOptions = {
          cache: cache,
          fetch: true,
          mode: mode,
          limit: 30
        };
        options = _.extend(defaultOptions, userOptions);
        cached = this._cache.has(key);
        if (cached) {
          entity = this._cache.get(key);
        } else {
          entity = new Entity;
          entity.status = this.entityStatus.NOT_READY;
          this._cache.set(key, entity);
        }
        promiseKey = '_promise';
        if (type === 'collection') {
          switch (options.mode) {
            case 'more':
              params.offset = params.offset || entity.length;
              params.limit = params.limit || options.limit;
              break;
            case 'reload':
              params.offset = 0;
              params.limit = entity.length || options.limit;
              break;
            default:
              params.offset = 0;
              params.limit = options.limit;
          }
          promiseKey = "" + promiseKey + "_o" + params.offset + "_l" + params.limit;
        }
        if (entity[promiseKey]) {
          return entity[promiseKey];
        }
        promise = new RSVP.Promise((function(_this) {
          return function(resolve, reject) {
            if (cached && options.cache) {
              resolve({
                entity: entity,
                cache: true
              });
              if (!options.fetch) {
                return;
              }
            }
            _this._fetchEntity(entity, params).then(function(data) {
              delete entity[promiseKey];
              return data;
            }).then(function(data) {
              var result, target;
              target = data;
              result = _this._getResult(entity, type, target);
              if (result.errorCode) {
                if (!cached) {
                  _this._cache.unset(key);
                }
                return reject({
                  code: result.errorCode,
                  message: result.errorMessage
                });
              } else if (options.mode === 'more') {
                entity.add(result);
              } else if (options.mode === 'reset') {
                entity.reset(result);
              } else {
                entity.set(result);
              }
              entity.status = _this.entityStatus.READY;
              resolve({
                entity: entity,
                data: result,
                cache: false
              });
              return null;
            }).then(null, function() {
              delete entity[promiseKey];
              if (!cached) {
                _this._cache.unset(key);
              }
              return reject();
            });
            return null;
          };
        })(this));
        if (options.fetch) {
          entity[promiseKey] = promise;
        }
        return promise;
      },
      _getKey: function(Entity, type, name, params) {
        var ret;
        if (params == null) {
          params = {};
        }
        ret = "" + type + ":" + name;
        if (_.has(Entity.prototype, 'apiParams')) {
          ret = _.foldl(Entity.prototype.apiParams, function(result, key) {
            if (_.has(params, key)) {
              result = "" + result + ":" + key + "_" + params[key];
            } else {
              throw "请求 " + type + "/" + name + " 时缺少参数：" + key;
            }
            return result;
          }, ret);
        }
        return ret;
      },
      _fetchEntity: function(entity, params) {
        var data, url, _ref;
        data = _.extend({}, params);
        if (!((_ref = entity.url) != null ? _ref.length : void 0)) {
          throw "未定义数据接口";
          return;
        }
        url = entity.url.replace(/\{\{(\w+)\}\}/g, function(placeholder, key) {
          var value;
          value = data[key];
          delete data[key];
          return value;
        });
        entity.status = this.entityStatus.PROCESSING;
        return RSVP.Promise.resolve(WJ.ajax(baseUrl + url, {
          type: "GET",
          dataType: 'json',
          data: data,
          xhrFields: {
            'Access-Control-Allow-Origin': '*'
          }
        }));
      },
      _getResult: function(entity, type, data) {
        var result;
        if (data.errorCode) {
          return data;
        }
        if (_.isFunction(entity.format)) {
          return result = entity.format(data.data);
        } else {
          return result = data.data;
        }
      },
      getCollection: function(name, params, userOptions) {
        var Entity, cached, entity, key, type;
        if (params == null) {
          params = {};
        }
        if (userOptions == null) {
          userOptions = {};
        }
        type = 'collection';
        Entity = this.collections[name];
        if (Entity) {
          key = this._getKey(Entity, type, name, params);
          cached = this._cache.has(key);
          if (cached) {
            entity = this._cache.get(key);
          } else {
            entity = new Entity;
            entity.status = this.entityStatus.NOT_READY;
            this._cache.set(key, entity);
          }
          return entity;
        }
        return null;
      },
      entityStatus: {
        NOT_READY: 10000,
        PROCESSING: 10001,
        READY: 10002
      }
    });
    return module.exports = DataCenter;
  });

}).call(this);
