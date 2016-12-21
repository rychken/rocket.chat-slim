Meteor.methods
	muteUserInRoom: (data) ->

		check(data, Match.ObjectIncluding({ rid: String, username: String }))

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'muteUserInRoom' }

		fromId = Meteor.userId()

		unless Sequoia.authz.hasPermission(fromId, 'mute-user', data.rid)
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'muteUserInRoom' }

		room = Sequoia.models.Rooms.findOneById data.rid
		if not room
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'muteUserInRoom' }

		if room.t not in ['c', 'p']
			throw new Meteor.Error 'error-invalid-room-type', room.t + ' is not a valid room type', { method: 'muteUserInRoom', type: room.t }

		if data.username not in (room?.usernames or [])
			throw new Meteor.Error 'error-user-not-in-room', 'User is not in this room', { method: 'muteUserInRoom' }

		mutedUser = Sequoia.models.Users.findOneByUsername data.username

		Sequoia.models.Rooms.muteUsernameByRoomId data.rid, mutedUser.username

		fromUser = Sequoia.models.Users.findOneById fromId
		Sequoia.models.Messages.createUserMutedWithRoomIdAndUser data.rid, mutedUser,
			u:
				_id: fromUser._id
				username: fromUser.username

		return true
