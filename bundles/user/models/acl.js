
// Require dependencies
const Model = require('model');

/**
 * Create acl model
 */
class Acl extends Model {
  /**
   * Sanitises acl class
   *
   * @return {*}
   */
  async sanitise(...args) {
    // Return id/name/value
    const sanitised = {
      id    : this.get('_id') ? this.get('_id').toString() : false,
      name  : this.get('name'),
      value : this.get('value'),
    };

    // sanitise acl
    await this.eden.hook('acl.sanitise', {
      sanitised,
      acl : this,
    }, ...args);

    // return sanitised
    return sanitised;
  }
}

/**
 * Export acl model
 * @type {acl}
 */
module.exports = Acl;
