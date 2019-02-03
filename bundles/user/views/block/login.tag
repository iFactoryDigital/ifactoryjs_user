<block-login>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } on-card={ onCard } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="block" class="block-wysiwyg">
    <yield to="body">
      <div class={ opts.block.card || 'card' }>
        <div class="card-header">
          Login
        </div>
        <div class="card-body">
          <form accept-charset="UTF-8" role="form" method="post" action="/login">
            <input type="hidden" if={ opts.redirect } value={ opts.redirect } name="redirect" />
            <div class="form-group">
              <input class="form-control" placeholder="Username / Email" name="username" type="text" value={ opts.old ? opts.old.username : '' } autocomplete="email">
            </div>
            <div class="form-group">
              <input class="form-control" placeholder="Password" name="password" type="password" autocomplete="current-password">
            </div>
            <button class="btn btn-success btn-block" type="submit">
              Login
            </button>
            <a class="btn btn-primary btn-block" href="/register{ opts.redirect ? '?redirect=' + opts.redirect : '' }">
              No account?
            </a>
          </form>
        </div>
      </div>
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
</block-login>
