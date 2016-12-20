Sequoia.authz.addUserRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = Sequoia.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'error-invalid-user', 'Invalid user', { function: 'Sequoia.authz.addUserRoles' }

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(Sequoia.authz.getRoles(), '_id')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		for role in invalidRoleNames
			Sequoia.models.Roles.createOrUpdate role

	Sequoia.models.Roles.addUserRoles(userId, roleNames, scope)

	return true
