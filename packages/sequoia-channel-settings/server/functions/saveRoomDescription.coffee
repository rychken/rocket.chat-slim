Sequoia.saveRoomDescription = (rid, roomDescription, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'Sequoia.saveRoomDescription' }

	roomDescription = s.escapeHTML(roomDescription)

	update = Sequoia.models.Rooms.setDescriptionById rid, roomDescription

	Sequoia.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_description', rid, roomDescription, user

	return update
