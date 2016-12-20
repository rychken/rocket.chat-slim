Sequoia.saveRoomTopic = (rid, roomTopic, user, sendMessage=true) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'Sequoia.saveRoomTopic' }

	roomTopic = s.escapeHTML(roomTopic)

	update = Sequoia.models.Rooms.setTopicById(rid, roomTopic)

	if update and sendMessage
		Sequoia.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_topic', rid, roomTopic, user

	return update
