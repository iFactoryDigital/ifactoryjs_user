<element-role>
  <span each={ item, i in this.roles }>
    <a href="/admin/role/{ item.id }/update">{ item.name }</a>
    { i === this.roles.length - 1 ? '' : ', ' }
  </span>
  
  <script>
    // set users
    this.roles = (Array.isArray(opts.data.value) ? opts.data.value : [opts.data.value]).filter(v => v);
    
  </script>
</element-role>
