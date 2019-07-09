/* eslint-disable global-require */

// Create mixin
riot.mixin('acl', {
  /**
   * On init function
   */
  init() {
    // Set value
    this.acl = require('user/public/js/acl');
  },
});
