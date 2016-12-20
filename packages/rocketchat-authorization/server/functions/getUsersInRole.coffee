Sequoia.authz.getUsersInRole = (roleName, scope, options) ->
	return Sequoia.models.Roles.findUsersInRole(roleName, scope, options)
