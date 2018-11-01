// Require local dependencies
const Model = require('model');

/**
 * Create login model class
 */
class Login extends Model {

  /**
   * Construct login model class
   */
  constructor () {
    // Run super
    super(...arguments);
  }

}

/**
 * Export login model class
 *
 * @type {login}
 */
exports = module.exports = Login;
