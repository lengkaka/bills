var require = {
    // baseUrl: 'http://115.28.10.1/bills/lib/',
    baseUrl: 'http://localhost/bills/lib/',
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
        'module': '../module',
        'view': '../view',
        'entities': '../entities',
        'controller': '../controller',
        'model': '../model',
        'collection': '../collection',
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
