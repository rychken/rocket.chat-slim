Meteor.methods
	'authorization:saveRole': (roleData) ->
		if not Meteor.userId() or not Sequoia.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error "error-action-not-allowed", 'Accessing permissions is not allowed', { method: 'authorization:saveRole', action: 'Accessing_permissions' }

		if not roleData.name?
			throw new Meteor.Error 'error-role-name-required', 'Role name is required', { method: 'authorization:saveRole' }

		if roleData.scope not in ['Users', 'Subscriptions']
			roleData.scope = 'Users'

		update = Sequoia.models.Roles.createOrUpdate roleData.name, roleData.scope, roleData.description

		if Sequoia.settings.get('UI_DisplayRoles')
			Sequoia.Notifications.notifyAll('roles-change', { type: 'changed', _id: roleData.name });

		return update
