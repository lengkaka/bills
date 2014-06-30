<tr>
    <th class="table-header-index"></th>
    {{#each fields}}
    <th field_id="{{this.id}}" class="table-header-row" field_type="{{this.type}}">{{this.name}}</th>
    {{/each}}
    <th class="col-md-1">opers</th>
</tr>