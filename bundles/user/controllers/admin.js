
// Bind dependencies
const Grid        = require('grid');
const alert       = require('alert');
const config      = require('config');
const crypto      = require('crypto');
const Controller  = require('controller');
const escapeRegex = require('escape-string-regexp');

// Require models
const Acl   = model('acl');
const User  = model('user');
const Block = model('block');

// require helpers
const formHelper  = helper('form');
const fieldHelper = helper('form/field');
const blockHelper = helper('cms/block');

/**
 * Build user admin controller
 *
 * @acl   admin.users.view
 * @fail  /
 * @mount /admin/user
 */
class AdminUserController extends Controller {
  /**
   * Construct user admin controller
   */
  constructor() {
    // Run super
    super();

    // Bind methods
    this.gridAction = this.gridAction.bind(this);
    this.indexAction = this.indexAction.bind(this);
    this.createAction = this.createAction.bind(this);
    this.updateAction = this.updateAction.bind(this);
    this.removeAction = this.removeAction.bind(this);
    this.createSubmitAction = this.createSubmitAction.bind(this);
    this.updateSubmitAction = this.updateSubmitAction.bind(this);
    this.removeSubmitAction = this.removeSubmitAction.bind(this);

    // Bind private methods
    this._grid = this._grid.bind(this);

    // register simple block
    blockHelper.block('dashboard.user.users', {
      acl         : ['admin.user'],
      for         : ['admin'],
      title       : 'Users Grid',
      description : 'Shows grid of users',
    }, async (req, block) => {
      // get notes block from db
      const blockModel = await Block.findOne({
        uuid : block.uuid,
      }) || new Block({
        uuid : block.uuid,
        type : block.type,
      });

      // create new req
      const fauxReq = {
        query : blockModel.get('state') || {},
      };

      // return
      return {
        tag  : 'grid',
        name : 'Users',
        grid : await this._grid(req).render(fauxReq),
      };
    }, async (req, block) => {
      // get notes block from db
      const blockModel = await Block.findOne({
        uuid : block.uuid,
      }) || new Block({
        uuid : block.uuid,
        type : block.type,
      });

      // set data
      blockModel.set('state', req.body.data.state);

      // save block
      await blockModel.save(req.user);
    });

    // register simple field
    fieldHelper.field('admin.role', {
      for         : ['frontend', 'admin'],
      title       : 'Role',
      description : 'Role field',
    }, async (req, field, value) => {
      // set tag
      field.tag = 'role';
      field.value = value ? (Array.isArray(value) ? await Promise.all(value.map(item => item.sanitise())) : await value.sanitise()) : null;
      // return
      return field;
    }, async (req, field) => {
      // save field
    }, async (req, field, value, old) => {
      // set value
      try {
        // set value
        value = JSON.parse(value);
      } catch (e) {}

      // check value
      if (!Array.isArray(value)) value = [value];

      // return value map
      return await Promise.all((value || []).filter(val => val).map(async (val, i) => {
        // run try catch
        try {
          // buffer company
          const acl = await Acl.findById(val);

          // check company
          if (acl) return acl;

          // return null
          return null;
        } catch (e) {
          // return old
          return old[i];
        }
      }));
    });
  }

  /**
   * Index action
   *
   * @param {Request}  req
   * @param {Response} res
   *
   * @icon    fa fa-user
   * @menu    {ADMIN} Users
   * @title   User Administration
   * @route   {get} /
   * @parent  /admin/config
   * @layout  admin
   */
  async indexAction(req, res) {
    // Render user admin page
    const grid = await this._grid(req).render(req);

    // Render grid
    res.render('user/admin', {
      grid,
    });
  }

  /**
   * index action
   *
   * @param req
   * @param res
   *
   * @acl   admin.user
   * @fail  next
   * @call  roles
   */
  async queryAction(query, opts) {
    // find children
    const roles = await Acl.where({
      name : new RegExp(escapeRegex(query), 'i'),
    }).skip(((parseInt(query.page, 10) || 1) - 1) * 20).limit(20).sort('name', 1)
      .find();

    // get children
    return await Promise.all(roles.map(role => role.sanitise()));
  }

  /**
   * Add/edit action
   *
   * @param {Request}  req
   * @param {Response} res
   * @return *
   *
   * @route    {get} /create
   * @route    {get} /:id/edit
   * @menu     {USERS} Add User
   * @layout   admin
   * @priority 12
   */
  createAction(req, res) {
    // Return update action
    return this.updateAction(req, res);
  }

  /**
   * Update action
   *
   * @param {Request}  req
   * @param {Response} res
   *
   * @route   {get} /:id/update
   * @layout  admin
   */
  async updateAction(req, res) {
    // Set website variable
    let user   = new User();
    let create = true;

    // Check for website model
    if (req.params.id) {
      // Load user
      user = await User.findById(req.params.id);
      create = false;
    }

    // get form
    const form = await formHelper.get('edenjs.user');

    // digest into form
    const sanitised = await formHelper.render(req, form, await Promise.all(form.get('fields').map(async (field) => {
      // return fields map
      return {
        uuid  : field.uuid,
        value : await user.get(field.name || field.uuid),
      };
    })));

    // get form
    if (!form.get('_id')) res.form('edenjs.user');

    // Render page
    res.render('user/admin/update', {
      item   : await user.sanitise(),
      form   : sanitised,
      title  : create ? 'Create New' : `Update ${user.get('username') || user.get('email')}`,
      fields : config.get('user.fields').map((field) => {
        // clone field
        field = JSON.parse(JSON.stringify(field));

        // delete field stuff
        delete field.format;
        delete field.filter;

        // return field
        return field;
      }),
    });
  }

  /**
   * Login as user
   *
   * @param  {Request}  req
   * @param  {Response} res
   *
   * @route   {get} /:id/login
   * @return {Promise}
   */
  async loginAsAction(req, res) {
    // Set website variable
    const user = await User.findById(req.params.id);

    // Login as user
    req.login(user, () => {
      // Redirect
      res.redirect('/');
    });
  }

  /**
   * Create submit action
   *
   * @param  {Response} req
   * @param  {Request}  res
   * @return *
   *
   * @route   {post} /create
   * @layout  admin
   */
  createSubmitAction(req, res) {
    // Return update action
    return this.updateSubmitAction(req, res);
  }

  /**
   * Add/edit action
   *
   * @param {Request}  req
   * @param {Response} res
   * @param {Function} next
   *
   * @route   {post} /:id/update
   * @layout  admin
   */
  async updateSubmitAction(req, res, next) {
    // Set website variable
    let user   = new User();
    let create = true;

    // Check for website model
    if (req.params.id) {
      // Load by id
      user = await User.findById(req.params.id);
      create = false;
    }

    // get form
    const form = await formHelper.get('edenjs.user');

    // digest into form
    const fields = await formHelper.submit(req, form, await Promise.all(form.get('fields').map(async (field) => {
      // return fields map
      return {
        uuid  : field.uuid,
        value : await user.get(field.name || field.uuid),
      };
    })));

    // loop fields
    for (const field of fields) {
      // set value
      user.set(field.name || field.uuid, field.value);
    }

    // Update user
    req.alert('success', `Successfully ${create ? 'created' : 'updated'} user`);

    // Save audit
    await user.save(req.user);

    // get user
    req.params.id = user.get('_id').toString();

    // Render page
    return this.updateAction(req, res, next);
  }

  /**
   * Delete action
   *
   * @param {Request}  req
   * @param {Response} res
   *
   * @route   {get} /:id/remove
   * @layout  admin
   */
  async removeAction(req, res) {
    // Set website variable
    let user = false;

    // Check for website model
    if (req.params.id) {
      // Load user
      user = await User.findById(req.params.id);
    }

    // Render page
    res.render('user/admin/remove', {
      item  : await user.sanitise(),
      title : `Remove ${user.get('username') || user.get('email')}`,
    });
  }

  /**
   * Delete action
   *
   * @param {Request}  req
   * @param {Response} res
   *
   * @route   {post} /:id/remove
   * @title   User Administration
   * @layout  admin
   */
  async removeSubmitAction(req, res) {
    // Set website variable
    let user = false;

    // Check for website model
    if (req.params.id) {
      // Load user
      user = await User.findById(req.params.id);
    }

    // Alert Removed
    req.alert('success', `Successfully removed ${user.get('username') || user.get('email')}`);

    // Delete website
    await user.remove(req.user);

    // Render index
    return this.indexAction(req, res);
  }

  /**
   * User alert emit
   *
   * @param {Object} data
   * @param {Object} opts
   *
   * @socket user.alert
   */
  async alertSocket(data, opts) {
    // Alert user
    alert.user(await User.findById(data.id), data.type, data.text);

    // Alert socket
    opts.alert('success', 'successfully sent alert');
  }

  /**
   * User grid action
   *
   * @param {Request}  req
   * @param {Response} res
   *
   * @route {post} /grid
   *
   * @returns {Promise}
   */
  gridAction(req, res) {
    // Return post grid request
    return this._grid(req).post(req, res);
  }

  /**
   * Renders grid
   *
   * @return {grid}
   */
  _grid(req) {
    // Create new grid
    const userGrid = new Grid(req);

    // Set route
    userGrid.route('/admin/user/grid');

    // Set grid model
    userGrid.model(User);

    // Add grid columns
    userGrid.column('_id', {
      title  : 'ID',
      width  : '1%',
      format : (col) => {
        return col ? `<a href="/admin/user/${col.toString()}/update">${col.toString()}</a>` : '<i>N/A</i>';
      },
    }).column('username', {
      sort   : true,
      title  : 'Username',
      format : (col) => {
        return col ? col.toString() : '<i>N/A</i>';
      },
      update : async (row, value) => {
        // Set value
        await row.lock();

        // Set username
        row.set('username', value);

        // Save
        await row.save(req.user);

        // Unlock
        row.unlock();
      },
    }).column('email', {
      sort   : true,
      title  : 'Email',
      format : (col) => {
        return col ? col.toString() : '<i>N/A</i>';
      },
      input  : 'email',
      update : async (row, value) => {
        // Set value
        await row.lock();

        // Set username
        row.set('email', value);

        // Save
        await row.save(req.user);

        // Unlock
        row.unlock();
      },
    }).column('acl', {
      title  : 'Roles',
      format : async (col, row) => {
        // Fetch acls
        const fetchedAcls = await row.get('acl');

        // Return if none
        if (fetchedAcls === null || fetchedAcls === undefined) {
          return '';
        }

        // Set acls
        const acls = fetchedAcls.filter(acl => acl && acl.get);

        // Return mapped
        return acls.map(acl => acl.get('name')).join(', ');
      },
    })
      .column('updated_at', {
        sort   : true,
        title  : 'Last Online',
        format : (col) => {
          return col ? col.toLocaleDateString('en-GB', {
            day   : 'numeric',
            month : 'short',
            year  : 'numeric',
          }) : '<i>N/A</i>';
        },
        input  : 'date',
        update : async (row, value) => {
        // Set value
          await row.lock();

          // Set username
          row.set('updated_at', new Date(value));

          // Save
          await row.save(req.user);

          // Unlock
          row.unlock();
        },
      })
      .column('created_at', {
        sort   : true,
        title  : 'Registered',
        format : (col) => {
          return col ? col.toLocaleDateString('en-GB', {
            day   : 'numeric',
            month : 'short',
            year  : 'numeric',
          }) : '<i>N/A</i>';
        },
        input  : 'date',
        update : async (row, value) => {
        // Set value
          await row.lock();

          // Set username
          row.set('created_at', new Date(value));

          // Save
          await row.save(req.user);

          // Unlock
          row.unlock();
        },
      })
      .column('actions', {
        type   : false,
        width  : '1%',
        title  : 'Actions',
        format : (col, row) => {
          return [
            '<div class="btn-group btn-group-sm" role="group">',
            `<a href="/admin/user/${row.get('_id').toString()}/update" class="btn btn-primary">`,
            '<i class="fa fa-pencil"></i>',
            '</a>',
            `<a href="/admin/user/${row.get('_id').toString()}/remove" class="btn btn-danger">`,
            '<i class="fa fa-times"></i>',
            '</a>',
            '</div>',
          ].join('');
        },
      });

    // Add grid filters
    userGrid.filter('username', {
      title : 'Username',
      type  : 'text',
      query : (param) => {
        // Another where
        userGrid.match('username', new RegExp(escapeRegex(param.toString().toLowerCase()), 'i'));
      },
    }).filter('email', {
      title : 'Email',
      type  : 'text',
      query : (param) => {
        // Another where
        userGrid.match('email', new RegExp(escapeRegex(param.toString().toLowerCase()), 'i'));
      },
    });

    // Set default sort order
    userGrid.sort('created_at', 1);

    // Return grid
    return userGrid;
  }
}

/**
 * Export admin controller
 *
 * @type {admin}
 */
exports = module.exports = AdminUserController;
