Sequoia.authz.hasRole = (userId, roleNames, scope) ->
	roleNames = [].concat roleNames
	return Sequoia.models.Roles.isUserInRoles(userId, roleNames, scope) # true if user is in ANY role
