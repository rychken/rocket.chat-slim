Meteor.publish 'roles', ->
	unless @userId
		return @ready()

	return Sequoia.models.Roles.find()

