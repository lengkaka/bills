var WJ = WJ || {};

// fix IE6 has't console
var console = window.console || {log: function() {}};
WJ.log = function() {
    if (WJ.debug) {
        var args = Array.prototype.slice.call(arguments, 0);
        console.log.apply(console, args);
    }
};

/**
 * WJ.core
 * 功能：伙伴JS核心方法库
 *
 *     作者: simon (jun.hrbeu@gmail.com)
 * 创建时间: 2014-06-02 07:36:35
 * 修改记录:
 *
 * $Id$
 */
define('core', function(require, exports, module) {

    var ViewHelper = require('view_helper');

    WJ.core = (function(WJ, $) {

        // 申明_core类
        var _core = {};

        /**
         * 展示载入中状态
         *
         * @param {mix} selector 选择器
         * @param {object} options 参数
         * @returns {unresolved} null
         */
        _core.loading = function(selector, options) {

            if (typeof(selector) === 'undefined') {
                return;
            }

            if (typeof(options) !== 'object') {
                options = {};
            }

            // var _loadingDiv = $('<div class="loading"><span>加载中...</span></div>');
            var _loadingDiv = $('<div class="loading"><span>加载中...</span></div>');

            if (typeof(options.width) !== 'undefined') {
                _loadingDiv.css('width', options.width + 'px');
            }

            if (typeof(options.height) !== 'undefined') {
                _loadingDiv.css('height', options.height + 'px');
            }

            if (typeof(options.className) !== 'undefined') {
                _loadingDiv.attr('class', options.className);
            }

            $(selector).html(_loadingDiv);
        };

        _core.getCollection = function (name, params, userOptions) {

            return WJ.dc.getCollection(name, params, userOptions);
        };
        return _core;

    })(WJ, jQuery);

    module.exports = WJ.core;
});
