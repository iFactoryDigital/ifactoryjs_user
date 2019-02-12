<user-admin-remove-page>
  <div class="page page-user">

    <admin-header title="Remove User">
      <yield to="right">
        <a href="/admin/user" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <form method="post" action="/admin/user/{ opts.item.id }/remove">
        <div class="card">
          <div class="card-body">
            Are you sure you want to delete <b>{ opts.item.username || opts.item.email }</b>?
          </div>
          <div class="card-footer text-right">
            <button type="submit" class="btn btn-primary">Submit</button>
          </div>
        </div>
      </form>
      
    </div>
  </div>

</user-admin-remove-page>
