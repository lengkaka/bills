define (require, exports, module) ->
    viewHelper = require 'view_helper'
    LoadingView = Marionette.ItemView.extend
        template: viewHelper.compile '<div class="loading"><span>加载中...</span></div>'

    module.exports = LoadingView