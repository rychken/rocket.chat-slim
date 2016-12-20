Meteor.methods
	getTotalChannels: ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getTotalChannels' }

		return Sequoia.models.Rooms.find({ t: 'c' }).count()
