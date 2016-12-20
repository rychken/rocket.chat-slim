Meteor.methods
	sendMessage: (message) ->
		if not Meteor.userId()
			return false

		if _.trim(message.msg) isnt ''
			if isNaN(TimeSync.serverOffset())
				message.ts = new Date()
			else
				message.ts = new Date(Date.now() + TimeSync.serverOffset())

			message.u =
				_id: Meteor.userId()
				username: Meteor.user().username

			message.temp = true

			message = Sequoia.callbacks.run 'beforeSaveMessage', message

			Sequoia.promises.run('onClientMessageReceived', message).then (message) ->
				ChatMessage.insert message
				Sequoia.callbacks.run 'afterSaveMessage', message
