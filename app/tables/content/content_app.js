// Generated by CoffeeScript 1.7.1
(function() {
  define(function(require, exports, module) {
    var App, LoadingView;
    App = require('app/application');
    require('app/tables/content/content_layout');
    require('app/tables/content/header/header_view');
    require('app/tables/content/detail/create');
    require('app/tables/content/detail/detail');
    require('app/tables/content/detail/delete');
    LoadingView = require('app/loading_view');
    return App.module('TablesApp.content', function(Content, App) {
      Content.controller = {
        _showloading: function() {
          var loadingView;
          loadingView = new LoadingView();
          return App.TablesApp.layout.content.show(loadingView);
        },
        _showLayout: function() {
          Content.layout = new Content.Layout();
          return App.TablesApp.layout.content.show(Content.layout);
        },
        _showTableHeader: function(tableId, tableModel, type) {
          var headerItems, headerListView;
          headerItems = App.request('tables:content:headers');
          headerListView = new Content.header.list({
            collection: headerItems,
            tableId: tableId,
            tableModel: tableModel,
            type: type
          });
          return Content.layout.header.show(headerListView);
        },
        showTableContent: function(tableId, tableModel, type) {
          var createView, deleteView, fields, loadingView;
          if (type === 'edit') {
            fields = App.request('tables:content:createTable', tableModel.get('fields'));
            createView = new Content.createView({
              model: tableModel,
              collection: fields,
              mode: 'edit'
            });
            return Content.layout.detail.show(createView);
          } else if (type === 'delete') {
            deleteView = new Content.deleteView({
              tableId: tableId,
              tableModel: tableModel
            });
            return Content.layout.detail.show(deleteView);
          } else {
            loadingView = new LoadingView();
            Content.layout.detail.show(loadingView);
            WJ.dc.request('collection/item', {
              tableId: tableId
            }).then((function(_this) {
              return function(_arg) {
                var entityCollection, listView, result;
                entityCollection = _arg.entity, result = _arg.data;
                WJ.log(entityCollection);
                listView = new Content.list({
                  itemCollection: entityCollection,
                  tableId: tableId,
                  tableModel: tableModel,
                  type: type
                });
                Content.layout.detail.show(listView);
                return false;
              };
            })(this)).then(function(params) {
              return false;
            });
            return null;
          }
        },
        showTable: function(tableId, tableModel) {
          this._showLayout();
          return this._showTableHeader(tableId, tableModel, 'view');
        },
        editTable: function(tableId, tableModel) {
          this._showLayout();
          this._showTableHeader(tableId, tableModel, 'edit');
          return this.showTableContent(tableId, tableModel, 'edit');
        },
        deleteTable: function(tableId, tableModel) {
          this._showLayout();
          this._showTableHeader(tableId, tableModel, 'delete');
          return this.showTableContent(tableId, tableModel, 'delete');
        },
        createTable: function() {
          var createView, fields;
          this._showLayout();
          fields = App.request('tables:content:createTable');
          createView = new Content.createView({
            collection: fields
          });
          return Content.layout.detail.show(createView);
        }
      };
      App.commands.setHandler('showTableContent', function(tableId, tableModel, type) {
        return Content.controller.showTableContent(tableId, tableModel, type);
      });
      App.commands.setHandler('showTable', function(tableId, tableModel) {
        return Content.controller.showTable(tableId, tableModel);
      });
      App.commands.setHandler('editTable', function(tableId, tableModel) {
        return Content.controller.editTable(tableId, tableModel);
      });
      App.commands.setHandler('deleteTable', function(tableId, tableModel) {
        return Content.controller.deleteTable(tableId, tableModel);
      });
      return App.commands.setHandler('createTable', function() {
        return Content.controller.createTable();
      });
    });
  });

}).call(this);