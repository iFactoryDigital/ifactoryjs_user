<block-register>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } on-card={ onCard } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="block" class="block-wysiwyg">
    <yield to="body">
      <form accept-charset="UTF-8" role="form" method="post" action="/register" class={ opts.block.card || 'card' }>
        <div class="card-header">
          Register
        </div>
        <div class="card-body">
          <input type="hidden" if={ opts.redirect } value={ opts.redirect } name="redirect" />
          <div class="form-group">
            <input class="form-control" placeholder="Username" name="username" type="text" value={ opts.old ? opts.old.username : '' } autocomplete="username">
          </div>
          <div class="form-group">
            <input class="form-control" placeholder="Email" name="email" type="email" value={ opts.old ? opts.old.email : '' } autocomplete="email">
          </div>
          <div class="form-group">
            <input class="form-control" placeholder="Password" name="password" type="password" autocomplete="new-password">
          </div>
          <div class="form-group">
            <input class="form-control" placeholder="Password Again" name="passwordb" type="password" autocomplete="new-password">
          </div>
          <button class="btn btn-success btn-block" type="submit">
            Register
          </button>
          <a class="btn btn-primary btn-block" href="/login{ opts.redirect ? '?url=' + opts.redirect : '' }">
            Already have an account?
          </a>
        </div>
      </form>
    </yield>
    
    <yield to="modal">
      <div class="form-group">
        <label>
          Card Class
        </label>
        <input class="form-control" ref="card" value={ opts.block.card } onchange={ opts.onCard } />
      </div>
    </yield>
  </block>

  <script>

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onUpdateContent (content) {
      // set name
      opts.data.content = content;

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onCard (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.block.card = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }

  </script>
</block-register>
