<tr>
    <td style="text-align: center">
        {{values.index}}
    </td>
    {{#each values.fields}}
        <td field_id="{{this.id}}" title="{{this.value}}" field_type="{{this.type}}" tabindex="1" style="cursor: pointer;">{{this.value}}</td>
    {{/each}}
    <td>
        <span style="cursor: pointer;" class="glyphicon glyphicon-pencil"></span>
        <span style="cursor: pointer;" class="glyphicon glyphicon-trash"></span>
    </td>
</tr>