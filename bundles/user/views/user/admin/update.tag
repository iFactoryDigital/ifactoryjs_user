<user-admin-update-page>
  <div class="page page-user">

    <admin-header title="{ opts.item.id ? 'Update' : 'Create' } User" preview={ this.preview } on-preview={ onPreview }>
      <yield to="right">
        <a href="/admin/user" class="btn btn-lg btn-primary mr-2">
          Back
        </a>
        <button class={ 'btn btn-lg' : true, 'btn-primary' : opts.preview, 'btn-success' : !opts.preview } onclick={ opts.onPreview }>
          { opts.preview ? 'Alter Form' : 'Finish Altering' }
        </button>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <div class="card">
        <div class="card-header">
          Update User
        </div>
        <div class="card-body">
          <form-render action="/admin/user/{ opts.item.id }/update" method="post" ref="form" form={ opts.form } placement="edenjs.user" positions={ this.positions } preview={ this.preview } class="d-block mb-3" />
        </div>
        <div class="card-footer text-right">
          <button type="button" onclick={ onSubmit } class={ 'btn btn-success' : true, 'disabled' : this.loading } disabled={ this.loading }>
            { this.loading ? 'Submitting...' : 'Submit' }
          </button>
        </div>
      </div>

      <div class="card mt-4" if={ opts.item.id }>
        <div class="card-header">
          Send Alert
        </div>
        <div class="card-body">
          <div class="form-group">
            <label for="type">Type</label>
            <select name="type" class="form-control">
              <option value="success">Success</option>
              <option value="error">Error</option>
              <option value="info">Info</option>
            </select>
          </div>
          <div class="form-group">
            <label for="username">Text</label>
            <input type="text" class="form-control" name="text" id="text" aria-describedby="text" placeholder="Enter text">
          </div>
        </div>
        <div class="card-footer text-right">
          <button class="btn btn-primary" onclick={ onAlert }>Send</button>
        </div>
      </div>
      <div class="card my-4" if={ opts.item.id }>
        <div class="card-header">
          Test User
        </div>
        <div class="card-body">
          <p>
            This will log you out of your current account and into this users account.
          </p>
        </div>
        <div class="card-footer text-right">
          <a href="/admin/user/{ opts.item.id }/login" class="btn btn-danger">Login as { opts.item.username }</a>
        </div>
      </div>
    </div>
  </div>

  <script>
    // do mixin
    this.mixin('i18n');

    // set type
    this.type    = opts.item.type || 'raised';
    this.preview = true;
    
    // require uuid
    const uuid = require('uuid');
    
    // set placements
    this.positions = opts.positions || opts.fields.map((field) => {
      // return field
      return {
        'type'     : field.type,
        'uuid'     : uuid(),
        'name'     : field.name,
        'label'    : field.label,
        'force'    : true,
        'multiple' : field.multiple,
        'children' : []
      };
    });
    
    /**
     * on submit
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    async onSubmit (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // submit form
      await this.refs.form.submit();
      
      // set loading
      this.loading = false;
      
      // update view
      this.update();
    }
    
    /**
     * on preview
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onPreview (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.preview = !this.preview;
      
      // update view
      this.update();
    }

    /**
     * get category
     *
     * @return {Object}
     */
    getUser() {
      // return category
      return opts.item;
    }
    
    /**
     * on alert function
     *
     * @param {Event} e
     */
    onAlert (e) {
      // prevent default
      e.preventDefault ();
      e.stopPropagation ();

      // get type
      let type = jQuery ('select[name="type"]', this.root).val ();
      let text = jQuery ('input[name="text"]', this.root).val ();

      // emit to socket
      socket.emit ('user.alert', {
        'id'   : opts.item.id,
        'type' : type,
        'text' : text
      });
    }
  </script>
</user-admin-update-page>
