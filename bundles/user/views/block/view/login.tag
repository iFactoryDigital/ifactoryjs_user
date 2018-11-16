<block-view-login>
  <div class={ opts.data.card || 'card' }>
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

  <script>
  

  </script>
</block-view-login>
