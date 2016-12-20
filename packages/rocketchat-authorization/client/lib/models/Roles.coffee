Sequoia.models.Roles = new Meteor.Collection 'sequoia_roles'

Sequoia.models.Roles.findUsersInRole = (name, scope, options) ->
	role = @findOne name
	roleScope = role?.scope or 'Users'
	Sequoia.models[roleScope]?.findUsersInRoles?(name, scope, options)

Sequoia.models.Roles.isUserInRoles = (userId, roles, scope) ->
	roles = [].concat roles
	_.some roles, (roleName) =>
		role = @findOne roleName
		roleScope = role?.scope or 'Users'
		return Sequoia.models[roleScope]?.isUserInRole?(userId, roleName, scope)

