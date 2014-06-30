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
    </div>
</div>
