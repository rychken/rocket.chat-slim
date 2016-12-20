atLeastOne = (userId, permissions, scope) ->
	return _.some permissions, (permissionId) ->
		permission = Sequoia.models.Permissions.findOne permissionId
		Sequoia.models.Roles.isUserInRoles(userId, permission.roles, scope)

all = (userId, permissions, scope) ->
	return _.every permissions, (permissionId) ->
		permission = Sequoia.models.Permissions.findOne permissionId
		Sequoia.models.Roles.isUserInRoles(userId, permission.roles, scope)

hasPermission = (userId, permissions, scope, strategy) ->
	unless userId
		return false

	permissions = [].concat permissions

	return strategy(userId, permissions, scope)



Sequoia.authz.hasAllPermission = (userId, permissions, scope) ->
	return hasPermission(userId, permissions, scope, all)

Sequoia.authz.hasPermission = Sequoia.authz.hasAllPermission

Sequoia.authz.hasAtLeastOnePermission = (userId, permissions, scope) ->
	return hasPermission(userId, permissions, scope, atLeastOne)
