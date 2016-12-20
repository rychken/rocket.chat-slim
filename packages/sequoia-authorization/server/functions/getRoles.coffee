Sequoia.authz.getRoles = ->
	return Sequoia.models.Roles.find().fetch()
