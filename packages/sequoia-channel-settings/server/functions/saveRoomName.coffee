Sequoia.saveRoomName = (rid, name, user, sendMessage=true) ->
	room = Sequoia.models.Rooms.findOneById rid

	if room.t not in ['c', 'p']
		throw new Meteor.Error 'error-not-allowed', 'Not allowed', { function: 'Sequoia.saveRoomName' }

	try
		nameValidation = new RegExp '^' + Sequoia.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test name
		throw new Meteor.Error 'error-invalid-room-name', name + ' is not a valid room name. Use only letters, numbers, hyphens and underscores', { function: 'Sequoia.saveRoomName', room_name: name }


	# name = _.slugify name

	if name is room.name
		return

	# avoid duplicate names
	if Sequoia.models.Rooms.findOneByName name
		throw new Meteor.Error 'error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'Sequoia.saveRoomName', channel_name: name }

	update = Sequoia.models.Rooms.setNameById(rid, name) and Sequoia.models.Subscriptions.updateNameAndAlertByRoomId(rid, name)
	if update and sendMessage
		Sequoia.models.Messages.createRoomRenamedWithRoomIdRoomNameAndUser rid, name, user

	return name
