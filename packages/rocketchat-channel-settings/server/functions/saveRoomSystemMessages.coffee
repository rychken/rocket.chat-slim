Sequoia.saveRoomSystemMessages = (rid, systemMessages, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'Sequoia.saveRoomSystemMessages' }

	update = Sequoia.models.Rooms.setSystemMessagesById rid, systemMessages

	return update
