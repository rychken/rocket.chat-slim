Sequoia.saveRoomType = (rid, roomType, user, sendMessage=true) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'Sequoia.saveRoomType' }

	if roomType not in ['c', 'p']
		throw new Meteor.Error 'error-invalid-room-type', 'error-invalid-room-type', { type: roomType }

	result = Sequoia.models.Rooms.setTypeById(rid, roomType) and Sequoia.models.Subscriptions.updateTypeByRoomId(rid, roomType)

	if result and sendMessage
		if roomType is 'c'
			message = TAPi18n.__('Channel', { lng: user?.language || Sequoia.settings.get('language') || 'en' })
		else
			message = TAPi18n.__('Private_Group', { lng: user?.language || Sequoia.settings.get('language') || 'en' })

		Sequoia.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_privacy', rid, message, user

	return result
