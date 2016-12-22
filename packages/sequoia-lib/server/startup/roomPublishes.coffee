Meteor.startup ->
	Sequoia.roomTypes.setPublish 'c', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				archived: 1
				ro: 1
				jitsiTimeout: 1
				description: 1
				sysMes: 1
				joinCodeRequired: 1

		if Sequoia.authz.hasPermission(this.userId, 'view-join-code')
			options.fields.joinCode = 1

		if Sequoia.authz.hasPermission(this.userId, 'view-c-room')
			return Sequoia.models.Rooms.findByTypeAndName 'c', identifier, options
		else if Sequoia.authz.hasPermission(this.userId, 'view-joined-room')
			roomId = Sequoia.models.Subscriptions.findByTypeNameAndUserId('c', identifier, this.userId).fetch()
			if roomId.length > 0
				return Sequoia.models.Rooms.findById(roomId[0]?.rid, options)

		return this.ready()

	Sequoia.roomTypes.setPublish 'p', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				archived: 1
				ro: 1
				jitsiTimeout: 1
				description: 1
				sysMes: 1

		user = Sequoia.models.Users.findOneById this.userId, fields: username: 1
		return Sequoia.models.Rooms.findByTypeAndNameContainingUsername 'p', identifier, user.username, options

	Sequoia.roomTypes.setPublish 'd', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				jitsiTimeout: 1

		user = Sequoia.models.Users.findOneById this.userId, fields: username: 1
		if Sequoia.authz.hasAtLeastOnePermission(this.userId, ['view-d-room', 'view-joined-room'])
			return Sequoia.models.Rooms.findByTypeContainigUsernames 'd', [user.username, identifier], options
		return this.ready()
