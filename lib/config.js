var require = {
    baseUrl: 'http://115.28.10.1/bills/lib/',
    paths: {
        'lib': '.',
        'jquery': 'jquery',
        'lodash': 'lodash',
        'backbone': 'backbone',
        'marionette': 'backbone.marionette',
        'rsvp': 'rsvp',
        'handlebars': 'handlebars',
        'bootstrap': '../bootstrap',
        'router': '../router',
        'app': '../app',
        'entities': '../entities',
        'controller': '../controller',
        'model': '../model',
        'collection': '../collection',
        'views': '../views',
        'templates': '../templates',
        'components': '../components'
    },
    shim: {
        'jquery': {
            exports: '$'
        },
        'lodash': {
            exports: '_'
        },
        'backbone': {
            deps: ['jquery', 'lodash'],
            exports: 'Backbone'
        },
        'marionette': {
            deps: ['jquery', 'lodash', 'backbone'],
            exports: 'Marionette'
        }
    }
};
