 define (require, exports, module) ->
    class application extends Spine.Model 
        @configure "bills"

    module.exports = application
