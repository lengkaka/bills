define(['view_helper'], function(ViewHelper) {
    return ViewHelper.compile('<div class=\"root\">{{#go}}go!{{else}}let\'s go!{{/go}}</div>');
});