/**
 * view_helper
 *
 *    作者: 付建宇 (jerray@huoban.com)
 * 创建时间: 2013-10-14 14:20:30
 * 修改记录:
 *
 * $Id: view_helper.js 298 2014-01-15 06:53:01Z wangjia $
 */
define(['handlebars'], function(Handlebars) {

    return (function(){

        var _this = this;

        /**
         * @param string template_string 模板字符串
         * @return function
         */
        _this.compile = function(template_string) {
            var template = Handlebars.compile(template_string);
            return function(view, partials) {
                var data = _.extend({}, view);
                return template(data, partials);
            };
        };

        /**
         * 扩展到模板数据中的方法
         */
        var helpers = {

          /**
           * {{#compare}}...{{/compare}}
           *
           * @credit: OOCSS
           * @param left value
           * @param operator The operator, must be between quotes ">", "=", "<=", etc...
           * @param right value
           * @param options option object sent by handlebars
           * @return {String} formatted html
           *
           * @example:
           *   {{#compare unicorns "<" ponies}}
           *     I knew it, unicorns are just low-quality ponies!
           *   {{/compare}}
           *
           *   {{#compare value ">=" 10}}
           *     The value is greater or equal than 10
           *     {{else}}
           *     The value is lower than 10
           *   {{/compare}}
           */
          compare: function(left, operator, right, options) {
            /*jshint eqeqeq: false*/

            if (arguments.length < 3) {
              throw new Error('Handlerbars Helper "compare" needs 2 parameters');
            }

            if (options === undefined) {
              options = right;
              right = operator;
              operator = '===';
            }

            var operators = {
              '==':     function(l, r) {return l == r; },
              '===':    function(l, r) {return l === r; },
              '!=':     function(l, r) {return l != r; },
              '!==':    function(l, r) {return l !== r; },
              '<':      function(l, r) {return l < r; },
              '>':      function(l, r) {return l > r; },
              '<=':     function(l, r) {return l <= r; },
              '>=':     function(l, r) {return l >= r; },
              'typeof': function(l, r) {return typeof l == r; }
            };

            if (!operators[operator]) {
              throw new Error('Handlerbars Helper "compare" doesn\'t know the operator ' + operator);
            }

            var result = operators[operator](left, right);

            if (result) {
              return options.fn(this);
            } else {
              return options.inverse(this);
            }
          }
      };

      // Aliases
      helpers.ifeq       = helpers.if_eq;
      helpers.unlessEq   = helpers.unless_eq;
      helpers.ifgt       = helpers.if_gt;
      helpers.unlessGt   = helpers.unless_gt;
      helpers.iflt       = helpers.if_lt;
      helpers.unlessLt   = helpers.unless_lt;
      helpers.ifgteq     = helpers.if_gteq;
      helpers.unlessGtEq = helpers.unless_gteq;
      helpers.ifLtEq     = helpers.if_lteq;
      helpers.unlessLtEq = helpers.unless_lteq;

      for (var helper in helpers) {
          if (helpers.hasOwnProperty(helper)) {
              Handlebars.registerHelper(helper, helpers[helper]);
          }
      }

      return _this;
    })();
});
