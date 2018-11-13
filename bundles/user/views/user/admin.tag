<user-admin-page>
  <div class="page page-user">

    <admin-header title="Manage Users">
      <yield to="right">
        <a href="/admin/user/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <grid grid={ opts.grid } table-class="table table-striped table-bordered" title="Users Grid" />
      
    </div>
  </div>
</user-admin-page>
