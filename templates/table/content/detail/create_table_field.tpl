{{#id}}
    <input style="display:none" type="text" name="fields[{{this}}][id]" value="{{this}}">
{{/id}}
<div class="col-xs-3">
    <input type="text" name="fields[{{id}}][name]" {{#name}}value="{{this}}"{{/name}} class="form-control" placeholder="请输入字段名">
</div>
<div class="col-xs-3">
    <select class="form-control" name="fields[{{id}}][type]">
        <option {{#compare type '==' 'string'}}selected{{/compare}}>字符串</option>
        <option {{#compare type '==' 'number'}}selected{{/compare}}>数字</option>
        <option {{#compare type '==' 'date'}}selected{{/compare}}>日期</option>
    </select>
</div>
<div class="col-xs-1 add_field" wj_add_field_id="{{id}}">
    <button type="button" class="btn btn-default btn-sm">
        <span class="glyphicon glyphicon-plus"></span>添加字段
    </button>
</div>
<div class="col-xs-1 delete_field" wj_remove_field_id="{{id}}">
    <button type="button" class="btn btn-default btn-sm">
        <span class="glyphicon glyphicon-remove"></span>删除字段
    </button>
</div>
