var WJ = WJ || {}
define(function(require, exports, module) {
    var _cache_request = {};
    WJ.ajax = function(url, options) {
        if (!_.isObject(options)) {
            options = {};
        }
        if (_.isString(url)) {
            options.url = url;
        } else if (_.isObject(url)) {
            options = url;
        }
        // deferred 对象
        var deferred = $.Deferred();
        var defaultOptions = {
            type: WJ.ajax.CONST.GET,
            unique: options.url
        };
        var settings = $.extend({}, defaultOptions, options);
        // ajax 
        var jqXHR = $.ajax(settings).done(function(result, textStatus, request) {
            var response = parseResponseData(result);
            deferred.resolve(result, textStatus, request);
        }).fail(function(request, textStatus, errThrown) {
            deferred.reject(request, textStatus, errThrown);
        }).always(function() {
            delete _cache_request[settings.unique];
            deferred.always();
        });
        _cache_request[settings.unique] = jqXHR;
        
        return deferred.promise();
    };

    // ajax常量
    WJ.ajax.CONST = {
        GET: 'GET',
        POST: 'POST'
    };

    function parseResponseData(result) {
        try {
            return $.parseJSON(result);
        } catch (e) {
            return result;
        }
    }

    module.exports = WJ.ajax;
});
