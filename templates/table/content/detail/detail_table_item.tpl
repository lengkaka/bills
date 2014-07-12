<td id="index" style="text-align: center">
    {{index}}
</td>
{{#each fields}}
    <td field_id="{{this.id}}" title="{{this.value}}" field_type="{{this.type}}" tabindex="1" style="cursor: pointer;">{{this.value}}</td>
{{/each}}
<td id="item-oper">
    <span id="item-edit" style="cursor: pointer;" class="glyphicon glyphicon-pencil"></span>
    <span id="item-delete" style="cursor: pointer;" class="glyphicon glyphicon-trash"></span>
</td>