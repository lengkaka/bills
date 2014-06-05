<form id="create_table_form">
    {{#_id}}
        <input style="display:none" type="text" name="_id" value="{{this}}">
    {{/_id}}
    {{#id}}
        <input style="display:none" type="text" name="id" value="{{this}}">
    {{/id}}
    <div class="form-group table_name">
        <label for="inputTableName">表名</label>
        <input type="text" name="name" {{#name}}value="{{this}}"{{/name}} class="form-control" id="inputTableName" placeholder="请输入表名">
    </div>
    <div class="form-group" wj_field_group="1">
        <label for="inputPassword">字段名</label>
    </div>
    <div class="table_fields">
    </div>
    <div class="footer">
        <button type="submit" wj_submit_create_table="1" class="btn btn-primary">提交</button>
    </div>
</form>
