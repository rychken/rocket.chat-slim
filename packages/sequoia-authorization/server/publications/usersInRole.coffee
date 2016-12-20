Meteor.publish 'usersInRole', (roleName, scope, limit = 50) ->
	unless @userId
		return @ready()

	if not Sequoia.authz.hasPermission @userId, 'access-permissions'
		return @error new Meteor.Error "error-not-allowed", 'Not allowed', { publish: 'usersInRole' }

	options =
		limit: limit
		sort:
			name: 1

	return Sequoia.authz.getUsersInRole roleName, scope, options
