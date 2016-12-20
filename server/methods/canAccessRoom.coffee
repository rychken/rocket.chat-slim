Meteor.methods
	canAccessRoom: (rid, userId) ->

		check rid, String
		check userId, String

		user = Sequoia.models.Users.findOneById userId, fields: username: 1

		unless user?.username
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'canAccessRoom' }

		unless rid
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'canAccessRoom' }

		room = Sequoia.models.Rooms.findOneById rid

		if room
			if Sequoia.authz.canAccessRoom.call(this, room, user)
				room.username = user.username
				return room
			else
				return false
		else
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'canAccessRoom' }
