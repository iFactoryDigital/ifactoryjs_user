<element-user>
  <span each={ item, i in this.users }>
    <a href="/admin/user/{ item.id }/update">{ item.name || item.username || item.email }</a>
    { i === this.users.length - 1 ? '' : ', ' }
  </span>
  
  <script>
    // set users
    this.users = (Array.isArray(opts.data.value) ? opts.data.value : [opts.data.value]).filter(v => v);
    
  </script>
</element-user>
