
// get dotProp
const dotProp = require('dot-prop');

// Create mixin
riot.mixin('user', {
  /**
   * On init function
   */
  init() {
    // On mount update
    if (!this.eden.frontend) {
      // Set acl
      this.user = {
        __data : this.eden.get('user') || {},
      };

      // set acl
      this.user.acl = require('user/public/js/acl');

      // Add get method
      this.user.get = (key) => {
        // Check key
        if (!key) return this.user.__data;

        // Return id
        return dotProp.get(this.user.__data, key);
      };

      // Add set method
      this.user.set = (key, value) => {
        // Return id
        dotProp.set(this.user.__data, key, value);
      };

      // Add normal functions
      this.user.exists = () => {
        // Return id
        return !!this.user.get('_id');
      };
    } else {
      // Check user loaded
      this.user = require('user/public/js/bootstrap');

      // On update
      this.user.on('update', this.update);

      // On unmount
      this.on('unmount', () => {
        // Remove on update
        this.user.removeListener('update', this.update);
      });
    }
  },
});
