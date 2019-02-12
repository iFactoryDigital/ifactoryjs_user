<field-role>
  <field ref="field" is-input={ true } class="field-container-inner" on-container-class={ onFieldClass } is-multiple={ true } get-fields={ getFields } get-element={ getElement } roles={ this.getRoles() }>
    <yield to="body">
      <div class={ opts.field.group || 'form-group' }>
        <label for={ opts.field.uuid }>
          { opts.field.label }
          <i if={ !opts.field.label }>Set Label</i>
        </label>
        <input name={ opts.field.uuid } type="hidden" ref="input" value={ JSON.stringify(opts.roles) } />
        <select required={ opts.field.required } class="{ opts.field.field || 'form-control' }{ 'form-control-active' : false }" multiple={ opts.field.multiple } ref="select" placeholder={ opts.field.label || 'Search by Name' }>
          <option each={ role, i in opts.data.value || [] } selected="true" value={ role.id }>
            { role.name }
          </option>
        </select>
      </div>
    </yield>
  </field>
  
  <script>
    // do mixins
    this.mixin('acl');
    
    // set initialized
    this.roles       = opts.data.value || [];
    this.__roles     = {};
    this.initialized = false;
    
    // loop value
    for (const value of this.roles) {
      // set to roles object
      this.__roles[value.id] = value;
    }

    /**
     * check should update
     */
    shouldUpdate(data) {
      // check initialized
      return !this.initialized;
    }
    
    /**
     * get roles
     *
     * @return {Array}
     */
    getRoles() {
      // get roles
      return this.roles.map(c => c.id);
    }

    /**
     * on mount function
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend || this.initialized) return;

      // do select 2
      jQuery(this.refs.field.refs.select).select2({
        'theme' : 'bootstrap4',
        'ajax'  : {
          'transport' : async (params, success, failure) => {
            // get schools
            let roles = (await socket.call('roles', params.data.q || ''));

            // add to schools
            roles.forEach((role) => {
              // check id
              if (!this.__roles[role.id]) this.__roles[role.id] = role;
            });

            // let data
            let data = {
              'results' : roles.map((result) => {
                // return id/text
                return {
                  'id'   : result.id,
                  'text' : result.name
                };
              })
            };

            // load from socket
            success(data);

            // return data
            return data;
          }
        },
        'multiple'    : opts.field.multiple,
        'placeholder' : opts.field.label || 'Search by Name'
      }).on('select2:select', (e) => {
        // get data
        let roles = jQuery(this.refs.field.refs.select).val();
        
        // set roles
        if (!Array.isArray(roles)) roles = [roles];

        // get school
        this.roles = roles.map((c) => this.__roles[c]);
        this.refs.field.refs.input.value = JSON.stringify(this.getRoles());
      });

      // set initialized
      this.initialized = true;
    });
    
  </script>
</field-role>
