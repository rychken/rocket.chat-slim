Sequoia.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser = (type, roomId, message, user, extraData) ->
	return @createWithTypeRoomIdMessageAndUser type, roomId, message, user, extraData

Sequoia.models.Messages.createRoomRenamedWithRoomIdRoomNameAndUser = (roomId, roomName, user, extraData) ->
	return @createWithTypeRoomIdMessageAndUser 'r', roomId, roomName, user, extraData
