Sequoia.saveRoomReadOnly = (rid, readOnly, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'Sequoia.saveRoomReadOnly' }

	update = Sequoia.models.Rooms.setReadOnlyById rid, readOnly

	return update
