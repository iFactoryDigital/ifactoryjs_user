<block-view-forgot>
  <div class={ opts.data.card || 'card' }>
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

  <script>
  

  </script>
</block-view-forgot>
