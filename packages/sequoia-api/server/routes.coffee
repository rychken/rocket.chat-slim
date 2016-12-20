Sequoia.API.v1.addRoute 'info', authRequired: false,
	get: -> Sequoia.Info


Sequoia.API.v1.addRoute 'me', authRequired: true,
	get: ->
		return _.pick @user, [
			'_id'
			'name'
			'emails'
			'status'
			'statusConnection'
			'username'
			'utcOffset'
			'active'
			'language'
		]


# Send Channel Message
Sequoia.API.v1.addRoute 'chat.messageExamples', authRequired: true,
	get: ->
		return Sequoia.API.v1.success
			body: [
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'rocket.cat'
				text: 'Sample text 1'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'rocket.cat'
				text: 'Sample text 2'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'rocket.cat'
				text: 'Sample text 3'
				trigger_word: 'Sample'
			]


# Send Channel Message
Sequoia.API.v1.addRoute 'chat.postMessage', authRequired: true,
	post: ->
		try
			messageReturn = processWebhookMessage @bodyParams, @user

			if not messageReturn?
				return Sequoia.API.v1.failure 'unknown-error'

			return Sequoia.API.v1.success
				ts: Date.now()
				channel: messageReturn.channel
				message: messageReturn.message
		catch e
			return Sequoia.API.v1.failure e.error

# Set Channel Topic
Sequoia.API.v1.addRoute 'channels.setTopic', authRequired: true,
	post: ->
		if not @bodyParams.channel?
			return Sequoia.API.v1.failure 'Body param "channel" is required'

		if not @bodyParams.topic?
			return Sequoia.API.v1.failure 'Body param "topic" is required'

		unless Sequoia.authz.hasPermission(@userId, 'edit-room', @bodyParams.channel)
			return Sequoia.API.v1.unauthorized()

		if not Sequoia.saveRoomTopic(@bodyParams.channel, @bodyParams.topic, @user)
			return Sequoia.API.v1.failure 'invalid_channel'

		return Sequoia.API.v1.success
			topic: @bodyParams.topic


# Create Channel
Sequoia.API.v1.addRoute 'channels.create', authRequired: true,
	post: ->
		if not @bodyParams.name?
			return Sequoia.API.v1.failure 'Body param "name" is required'

		if not Sequoia.authz.hasPermission(@userId, 'create-c')
			return Sequoia.API.v1.unauthorized()

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'createChannel', @bodyParams.name, []
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

		return Sequoia.API.v1.success
			channel: Sequoia.models.Rooms.findOneById(id.rid)

# List Private Groups a user has access to
Sequoia.API.v1.addRoute 'groups.list', authRequired: true,
	get: ->
		roomIds = _.pluck Sequoia.models.Subscriptions.findByTypeAndUserId('p', @userId).fetch(), 'rid'
		return { groups: Sequoia.models.Rooms.findByIds(roomIds).fetch() }

# Add All Users to Channel
Sequoia.API.v1.addRoute 'channel.addall', authRequired: true,
	post: ->

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'addAllUserToRoom', @bodyParams.roomId, []
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

		return Sequoia.API.v1.success
			channel: Sequoia.models.Rooms.findOneById(@bodyParams.roomId)

# List all users
Sequoia.API.v1.addRoute 'users.list', authRequired: true,
	get: ->
		if Sequoia.authz.hasRole(@userId, 'admin') is false
			return Sequoia.API.v1.unauthorized()

		return { users: Sequoia.models.Users.find().fetch() }

# Create user
Sequoia.API.v1.addRoute 'users.create', authRequired: true,
	post: ->
		try
			check @bodyParams,
				email: String
				name: String
				password: String
				username: String
				role: Match.Maybe(String)
				joinDefaultChannels: Match.Maybe(Boolean)
				requirePasswordChange: Match.Maybe(Boolean)
				sendWelcomeEmail: Match.Maybe(Boolean)
				verified: Match.Maybe(Boolean)
				customFields: Match.Maybe(Object)

			# check username availability first (to not create an user without a username)
			try
				nameValidation = new RegExp '^' + Sequoia.settings.get('UTF8_Names_Validation') + '$'
			catch
				nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

			if not nameValidation.test @bodyParams.username
				return Sequoia.API.v1.failure 'Invalid username'

			unless Sequoia.checkUsernameAvailability @bodyParams.username
				return Sequoia.API.v1.failure 'Username not available'

			userData = {}

			newUserId = Sequoia.saveUser(@userId, @bodyParams)

			if @bodyParams.customFields?
				Sequoia.saveCustomFields(newUserId, @bodyParams.customFields)

			user = Sequoia.models.Users.findOneById(newUserId)

			if typeof @bodyParams.joinDefaultChannels is 'undefined' or @bodyParams.joinDefaultChannels
				Sequoia.addUserToDefaultChannels(user)

			return Sequoia.API.v1.success
				user: user
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

# Update user
Sequoia.API.v1.addRoute 'user.update', authRequired: true,
	post: ->
		try
			check @bodyParams,
				userId: String
				data:
					email: Match.Maybe(String)
					name: Match.Maybe(String)
					password: Match.Maybe(String)
					username: Match.Maybe(String)
					role: Match.Maybe(String)
					joinDefaultChannels: Match.Maybe(Boolean)
					requirePasswordChange: Match.Maybe(Boolean)
					sendWelcomeEmail: Match.Maybe(Boolean)
					verified: Match.Maybe(Boolean)
					customFields: Match.Maybe(Object)

			userData = _.extend({ _id: @bodyParams.userId }, @bodyParams.data)

			Sequoia.saveUser(@userId, userData)

			if @bodyParams.data.customFields?
				Sequoia.saveCustomFields(@bodyParams.userId, @bodyParams.data.customFields)

			return Sequoia.API.v1.success
				user: Sequoia.models.Users.findOneById(@bodyParams.userId)
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

# Get User Information
Sequoia.API.v1.addRoute 'user.info', authRequired: true,
	post: ->
		if Sequoia.authz.hasRole(@userId, 'admin') is false
			return Sequoia.API.v1.unauthorized()

		return { user: Sequoia.models.Users.findOneByUsername @bodyParams.name }

# Get User Presence
Sequoia.API.v1.addRoute 'user.getpresence', authRequired: true,
	post: ->
		return { user: Sequoia.models.Users.findOne( { username: @bodyParams.name} , {fields: {status: 1}} ) }

# Delete User
Sequoia.API.v1.addRoute 'users.delete', authRequired: true,
	post: ->
		if not @bodyParams.userId?
			return Sequoia.API.v1.failure 'Body param "userId" is required'

		if not Sequoia.authz.hasPermission(@userId, 'delete-user')
			return Sequoia.API.v1.unauthorized()

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'deleteUser', @bodyParams.userId, []
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

		return Sequoia.API.v1.success

# Create Private Group
Sequoia.API.v1.addRoute 'groups.create', authRequired: true,
	post: ->
		if not @bodyParams.name?
			return Sequoia.API.v1.failure 'Body param "name" is required'

		if not Sequoia.authz.hasPermission(@userId, 'create-p')
			return Sequoia.API.v1.unauthorized()

		id = undefined
		try
			if not @bodyParams.members?
				Meteor.runAsUser this.userId, =>
					id = Meteor.call 'createPrivateGroup', @bodyParams.name, []
			else
			  Meteor.runAsUser this.userId, =>
				  id = Meteor.call 'createPrivateGroup', @bodyParams.name, @bodyParams.members, []
		catch e
			return Sequoia.API.v1.failure e.name + ': ' + e.message

		return Sequoia.API.v1.success
			group: Sequoia.models.Rooms.findOneById(id.rid)
