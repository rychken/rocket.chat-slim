Meteor.methods
	'authorization:removeRoleFromPermission': (permission, role) ->
		if not Meteor.userId() or not Sequoia.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error "error-action-not-allowed", "Accessing permissions is not allowed", { method: 'authorization:removeRoleFromPermission', action: 'Accessing_permissions' }

		Sequoia.models.Permissions.removeRole permission, role
