// Require daemon
const Daemon = require('daemon');

// Require models
const User = model('user');

/**
 * Create user daemon
 *
 * @compute 0
 * @extends daemon
 */
class UserDaemon extends Daemon {
  /**
   * Constructor
   */
  constructor(...args) {
    // Run arguments
    super(...args);

    // Bind build
    this.build = this.build.bind(this);

    // Bind building
    this.building = this.build();
  }

  /**
   * Build user daemon
   */
  build() {
    // Add listeners for events
    this.eden.on('model.save', async (opts) => {
      // check model
      if (opts.model !== 'user') return;

      // get user
      const user = await User.findById(opts.id);

      // emit changes to user
      user.emit('user', await user.sanitise());
    }, true);
  }
}

/**
 * Build live daemon class
 *
 * @type {UserDaemon}
 */
module.exports = UserDaemon;
