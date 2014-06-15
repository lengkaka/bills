<tr>
    <td style="text-align: center">
        {{values.index}}
    </td>
    {{#each values.fields}}
        <td field_id="{{this.id}}" tabindex="1" style="cursor: pointer;">{{this.value}}</td>
    {{/each}}
    <td>
        <span style="cursor: pointer;" class="glyphicon glyphicon-pencil"></span>
        <span style="cursor: pointer;" class="glyphicon glyphicon-trash"></span>
    </td>
</tr>