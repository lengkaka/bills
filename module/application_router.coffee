define (require, exports, module) ->
    router = Marionette.AppRouter.extend
        appRoutes:
            "(*path)": "notFound"

        onRoute: (name, path, args) ->
            console.log("application_router onRoute fired")
            console.log(name, path, args)
    
    module.exports = router
