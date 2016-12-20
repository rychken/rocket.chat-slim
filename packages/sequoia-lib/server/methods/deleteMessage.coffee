Meteor.methods
	deleteMessage: (message) ->

		check message, Match.ObjectIncluding({_id:String})

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'deleteMessage' }

		originalMessage = Sequoia.models.Messages.findOneById message._id, {fields: {u: 1, rid: 1, file: 1}}
		if not originalMessage?
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		hasPermission = Sequoia.authz.hasPermission(Meteor.userId(), 'delete-message', originalMessage.rid)
		deleteAllowed = Sequoia.settings.get 'Message_AllowDeleting'

		deleteOwn = originalMessage?.u?._id is Meteor.userId()

		unless hasPermission or (deleteAllowed and deleteOwn)
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		blockDeleteInMinutes = Sequoia.settings.get 'Message_AllowDeleting_BlockDeleteInMinutes'
		if blockDeleteInMinutes? and blockDeleteInMinutes isnt 0
			msgTs = moment(originalMessage.ts) if originalMessage.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			if currentTsDiff > blockDeleteInMinutes
				throw new Meteor.Error 'error-message-deleting-blocked', 'Message deleting is blocked', { method: 'deleteMessage' }

		Sequoia.deleteMessage(originalMessage, Meteor.user());
