Meteor.methods
	saveRoomSettings: (rid, setting, value) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { function: 'Sequoia.saveRoomName' })

		unless Match.test rid, String
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'saveRoomSettings' }

		if setting not in ['roomName', 'roomTopic', 'roomDescription', 'roomType', 'readOnly', 'systemMessages', 'default', 'joinCode']
			throw new Meteor.Error 'error-invalid-settings', 'Invalid settings provided', { method: 'saveRoomSettings' }

		unless Sequoia.authz.hasPermission(Meteor.userId(), 'edit-room', rid)
			throw new Meteor.Error 'error-action-not-allowed', 'Editing room is not allowed', { method: 'saveRoomSettings', action: 'Editing_room' }

		if setting is 'default' and not Sequoia.authz.hasPermission(@userId, 'view-room-administration')
			throw new Meteor.Error 'error-action-not-allowed', 'Viewing room administration is not allowed', { method: 'saveRoomSettings', action: 'Viewing_room_administration' }

		room = Sequoia.models.Rooms.findOneById rid
		if room?
			switch setting
				when 'roomName'
					name = Sequoia.saveRoomName rid, value, Meteor.user()
				when 'roomTopic'
					if value isnt room.topic
						Sequoia.saveRoomTopic(rid, value, Meteor.user())
				when 'roomDescription'
					if value isnt room.description
						Sequoia.saveRoomDescription rid, value, Meteor.user()
				when 'roomType'
					if value isnt room.t
						Sequoia.saveRoomType(rid, value, Meteor.user())
				when 'readOnly'
					if value isnt room.ro
						Sequoia.saveRoomReadOnly rid, value, Meteor.user()
				when 'systemMessages'
					if value isnt room.sysMes
						Sequoia.saveRoomSystemMessages rid, value, Meteor.user()
				when 'joinCode'
					Sequoia.models.Rooms.setJoinCodeById rid, String(value)
				when 'default'
					Sequoia.models.Rooms.saveDefaultById rid, value

		return { result: true, rid: room._id }
