/*
Copyright (c) 2014 simon

Licensed under the MIT license
http://en.wikipedia.org/wiki/MIT_License
*/
(function($){

    //////////////////////////////////////// init  //////////////////////////////////////
    $.fn.customTable = function(options) {
        var _this = this;
        _this.settings = {
            add: null,
            edit: null,
            save: null,     // return false if not validate
            deleteRow: null,
            change: null,
            selected: null
        };
        if (options) {
            _this.settings = _.extend(_this.settings, options);
        }
        var $tableBody = _this.find('tbody');
        var $tableHeader = _this.find('thead');

        /////////////////////////////////////// private methods //////////////////////////////////////
        // clear table events
        var clearTableEvents = function() {
            $tableBody.find('tr').unbind();
            $tableBody.find('span').unbind();
        };

        // clear table's one row evnets
        var clearRowEvents = function($tr) {
            $tr.unbind();
            $tr.find('spna').unbind();
        };

        // get the num of rows in table
        var getRowNumInTable = function() {
            return $tableBody.find('tr').length;
        };

        ///////////////////////////// table data operations ///////////////////////////////
        // get rowIndex by row
        var findRowIndexByTR = function($tr) {
            return _this.find('tr').index($tr) - 1;
        };

        // get row by rowIndex, form 0 start
        var getRowByIndex = function(rowIndex) {
            return $tableBody.find('tr').eq(rowIndex);
        };

        // force row into edit staatus
        var setRowIntoEdit = function(rowIndex) {
            $row = getRowByIndex(rowIndex);
            $row.find('span.glyphicon-pencil').click();
        };

        // get header titles, {field_id: name, ...}
        var getTableObjHeaders = function() {

            var headers = {};
            $ths = $tableHeader.find('tr th');
            if ($ths && $ths.length > 0) {
                var thsLength = $ths.length;
                $.each($ths, function(index, th) {
                    var $th = $(th);
                    if (index > 0 && index < thsLength - 1) {
                        headers[parseInt($th.attr('field_id'))] = $th.html();
                    }
                });
            }

            return headers;
        };

        /////////////////////////////////////// bind events //////////////////////////////////
        // bind table events
        var bindTableEvents = null;
        bindTableEvents = function() {
            // select item
            $tableBody.find('tr').bind('click', function(e) {
                var rowIndex = findRowIndexByTR($(this));
                if ($(this).attr('status') === 'edit') {
                    return;
                }
                if (_this.settings.selected) {
                    // selected callback
                    _this.settings.selected(_this, rowIndex);
                }
            });

            var handleRowEditEvent = null;
            handleRowEditEvent = function($tr) {
                var rowIndex = findRowIndexByTR($tr);
                var $tds = $tr.find('td[tabindex]');
                var $replaceSelector = null;
                if ($tr.find('span.glyphicon-ok') && $tr.find('span.glyphicon-ok').length > 0) {
                    var canSave = true;
                    if (_this.settings.save) {
                        // save callback
                        // if return false，keep edit mode
                        canSave = _this.settings.save(_this, rowIndex, _this.getTableRowObj(rowIndex));
                    }
                    if (!canSave) {
                        return;
                    }
                    // into save status
                    $.each($tds, function(index, td) {
                        var $td = $(td);
                        var content = $td.find('input').val();
                        $td.html(content);
                    });
                    $tr.removeAttr('status');
                    $replaceSelector = $().add('<span style="cursor: pointer;" class="glyphicon glyphicon-pencil"></span>');
                    $tr.find('span.glyphicon-ok').replaceWith($replaceSelector);
                } else {
                    // into edit status
                    // each td insert input
                    $.each($tds, function(index, td) {
                        var $td = $(td);
                        var content = $td.html();

                        var $container = $().add('<div class="table-items-detail-content-main-row-div"><input type="text" class="table-items-detail-content-main-row-div-row"></div>');
                        var $input = $container.find('input');
                        $input.val(content);
                        $td.html($container);
                        var isDate = $td.attr('field_type') === 'date' ? true : false;
                        if (isDate) {
                            $input.css('width', '80%');
                            $input.datepicker({dateFormat: "yy-mm-dd"});
                            $container.append('<span class="glyphicon glyphicon-calendar"></span>');
                        }
                    });
                    $tr.attr('status', 'edit');
                    $replaceSelector = $().add('<span style="cursor: pointer;" class="glyphicon glyphicon-ok"></span>');
                    $tr.find('span.glyphicon-pencil').replaceWith($replaceSelector);
                }

                // edit item
                $replaceSelector.bind('click', function(e) {
                    $tr = $(this).closest('tr');
                    handleRowEditEvent($tr);
                    e.preventDefault();
                    return false;
                });
            };

            // edit item
            $tableBody.find('span.glyphicon-pencil, span.glyphicon-ok').bind('click', function(e) {
                $tr = $(this).closest('tr');
                handleRowEditEvent($tr);
                e.preventDefault();
                return false;
            });

            // delete item
            $tableBody.find('span.glyphicon-trash').bind('click', function(e) {
                $tr = $(this).closest('tr');
                var rowIndex = findRowIndexByTR($tr);

                _this.removeRowByIndex(rowIndex);

                if (_this.settings.deleteRow) {
                    // delete row callback
                    _this.settings.deleteRow(_this, rowIndex);
                }
                e.preventDefault();
                return false;
            });
        };

        /////////////////////////////////////// insert and remove row /////////////////////////////////////////
        _this.insertNewRow = function() {
            // insert new row to front
            if (!_this.settings.insertRow) {
                return;
            }

            var newRow = _this.settings.insertRow();
            $tableBody.prepend(newRow);
            // update item index
            var $trs = $tableBody.find('tr');
            if ($trs && $trs.length > 0) {
                _.each($trs, function(tr, index) {
                    var $tr = $(tr);
                    var $indexTD = $tr.find('td').eq(0);
                    if ($indexTD && $indexTD.length > 0) {
                        $indexTD.html(index + 1);
                    }
                });
            }

            clearTableEvents();

            bindTableEvents();

            if (_this.settings.add) {
                // add callback
                _this.settings.add(_this, 0, _this.getTableRowObj(0));
            }
            setRowIntoEdit(0);
        };

        _this.removeLastRow = function() {
            var rowNum = getRowNumInTable();
            if (rowNum > 0) {
                _this.removeRowByIndex(rowNum - 1);
            }
        };

        // remove row
        _this.removeRowByIndex = function(index) {
            $removeTR = $tableBody.find('tr').eq(index);
            if ($removeTR && $removeTR.length === 1) {
                // remove DOM, also remove events and data
                $removeTR.remove();
            }
        };

        // 获取某一行的内容对象
        _this.getTableRowObj = function(rowIndex) {
            var headers = getTableObjHeaders();
            var $row = getRowByIndex(rowIndex);
            var fields = [];
            if ($row && $row.length === 1) {
                var $tds = $row.find('td');
                var tdsLength = $tds.length;
                $.each($tds, function(index, td) {
                    var $td = $(td);
                    if (index > 0 && index < tdsLength - 1) {
                        var value = null;
                        if ($row.attr('status') === 'edit') {
                            value = $.trim($td.find('input').val());
                        } else {
                            value = $.trim($td.html());
                        }
                        var field = {};
                        field.id = parseInt($td.attr('field_id'));
                        field.name = headers[field.id];
                        field.type = $td.attr('field_type');
                        field.value = value;
                        fields.push(field);
                    }
                });
            }

            return fields;
        };

        /////////////////////////////////////// logic /////////////////////////////
        bindTableEvents();

        return this;
    };

})(jQuery);