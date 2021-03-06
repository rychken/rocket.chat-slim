Meteor.methods
	archiveRoom: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'archiveRoom' }

		room = Sequoia.models.Rooms.findOneById rid

		unless room
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'archiveRoom' }

		unless Sequoia.authz.hasPermission(Meteor.userId(), 'archive-room', room._id)
			throw new Meteor.Error 'error-not-authorized', 'Not authorized', { method: 'archiveRoom' }

		Sequoia.archiveRoom(rid)
