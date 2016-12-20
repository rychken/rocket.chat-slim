Meteor.methods
	getRoomIdByNameOrId: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getRoomIdByNameOrId' }

		room = Sequoia.models.Rooms.findOneById(rid) or Sequoia.models.Rooms.findOneByName(rid)

		if not room?
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'getRoomIdByNameOrId' }

		if room.usernames.indexOf(Meteor.user()?.username) isnt -1
			return room._id

		if room.t isnt 'c' or Sequoia.authz.hasPermission(Meteor.userId(), 'view-c-room') isnt true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'getRoomIdByNameOrId' }

		return room._id
