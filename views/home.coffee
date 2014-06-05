define (require, exports, module) ->
    home = Marionette.ItemView.extend
        template: "<div>Home<a href=\"users\">users</a></div>"
        events:
            "click a": "jump"
        jump: (e)->
            e.preventDefault()
            myApp.router.navigate("users/111/tile/222/ddd/333", true)

    module.exports = home
