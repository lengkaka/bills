var Application = Application || {};
var WJ = WJ || {};

define(function(require, exports, module) {
    require('ajax');
    WJ.debug = true;
    require('core');
    var DataCenter = require('data_center');
    $(function() {
        myApp = require('app/application');
        WJ.dc = new DataCenter();
        // subModule tables
        require('entities/header');
        require('entities/tables');
        require('app/tables/tables_app');
        require('app/header/header_app');

        myApp.start();
    });
});

