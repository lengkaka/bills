<div class="table-items-detail">
    <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading">表格操作</div>
        <div class="panel-body">
            <!-- search bar -->
            <form class="navbar-form navbar-left" role="search">
                <div class="form-group">
                    <input type="text" id="search" class="form-control" placeholder="Search">
                </div>
                <button type="submit" class="btn btn-default">Submit</button>
            </form>
            <div class="table-operation btn-group">
                <button type="button" id="create_row" class="btn btn-success">新建Item</button>
            </div>

            <div class="table-date-set btn-group">
                <input type="text" id="set-date" class="form-control" placeholder="选择日期">
                <button type="button" id="filter_by_created_on" class="btn btn-success">筛选</button>
            </div>
        </div>
    </div>
    <div class="table-items-detail-content">
        <div class="table-items-detail-content-main">
            <table id="mainTable" class="table table-striped table-bordered table-hover">
                <thead>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="table-items-detail-content-header">
            <table id="header-fixed" class="table table-striped table-bordered table-hover"></table>
        </div>
        <div class="modal fade" id="delete-dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h4 class="modal-title">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        <p>One fine body&hellip;</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>
    </div>
</div>
