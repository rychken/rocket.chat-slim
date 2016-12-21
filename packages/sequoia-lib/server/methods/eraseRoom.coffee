Meteor.methods
	eraseRoom: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'eraseRoom' }

		fromId = Meteor.userId()

		roomType = Sequoia.models.Rooms.findOneById(rid)?.t

		if Sequoia.authz.hasPermission( fromId, "delete-#{roomType}", rid )
			# ChatRoom.update({ _id: rid}, {'$pull': { userWatching: Meteor.userId(), userIn: Meteor.userId() }})

			Sequoia.models.Messages.removeByRoomId rid
			Sequoia.models.Subscriptions.removeByRoomId rid
			Sequoia.models.Rooms.removeById rid
			# @TODO remove das mensagens lidas do usuário
		else
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'eraseRoom' }
