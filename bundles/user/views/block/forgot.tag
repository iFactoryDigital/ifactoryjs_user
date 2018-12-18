<block-forgot>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } on-card={ onCard } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="block" class="block-wysiwyg">
    <yield to="body">
      <div class={ opts.block.card || 'card' }>
        <h4 class="card-header text-xs-center">
          Reset Password
        </h4>
        <div class="card-block">
          <form accept-charset="UTF-8" role="form" method="post" action="/reset">
            <input type="hidden" name="token" value={ opts.token } />
            <div class="form-group">
              <input class="form-control" placeholder="Password" name="password" type="password">
            </div>
            <div class="form-group">
              <input class="form-control" placeholder="Password Again" name="passwordb" type="password">
            </div>
            <button class="btn btn-success btn-block" type="submit">
              Submit
            </button>
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
</block-forgot>
