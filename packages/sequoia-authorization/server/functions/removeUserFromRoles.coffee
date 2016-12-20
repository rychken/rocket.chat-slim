Sequoia.authz.removeUserFromRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = Sequoia.models.Users.findOneById(userId)
	if not user?
		throw new Meteor.Error 'error-invalid-user', 'Invalid user', { function: 'Sequoia.authz.removeUserFromRoles' }

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(Sequoia.authz.getRoles(), '_id')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		throw new Meteor.Error 'error-invalid-role', 'Invalid role', { function: 'Sequoia.authz.removeUserFromRoles' }

	Sequoia.models.Roles.removeUserRoles(userId, roleNames, scope)

	return true
