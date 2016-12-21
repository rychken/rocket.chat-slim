Meteor.methods
	removeUserFromRoom: (data) ->

		check(data, Match.ObjectIncluding({ rid: String, username: String }))

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeUserFromRoom' }

		fromId = Meteor.userId()

		unless Sequoia.authz.hasPermission(fromId, 'remove-user', data.rid)
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeUserFromRoom' }

		room = Sequoia.models.Rooms.findOneById data.rid

		if data.username not in (room?.usernames or [])
			throw new Meteor.Error 'error-user-not-in-room', 'User is not in this room', { method: 'removeUserFromRoom' }

		removedUser = Sequoia.models.Users.findOneByUsername data.username

		if Sequoia.authz.hasRole(removedUser._id, 'owner', room._id)
			numOwners = Sequoia.authz.getUsersInRole('owner', room._id).fetch().length
			if numOwners is 1
				throw new Meteor.Error 'error-you-are-last-owner', 'You are the last owner. Please set new owner before leaving the room.', { method: 'removeUserFromRoom' }

		Sequoia.models.Rooms.removeUsernameById data.rid, data.username

		Sequoia.models.Subscriptions.removeByRoomIdAndUserId data.rid, removedUser._id

		if room.t in [ 'c', 'p' ]
			Sequoia.authz.removeUserFromRoles(removedUser._id, ['moderator', 'owner'], data.rid)

		fromUser = Sequoia.models.Users.findOneById fromId
		Sequoia.models.Messages.createUserRemovedWithRoomIdAndUser data.rid, removedUser,
			u:
				_id: fromUser._id
				username: fromUser.username

		return true
