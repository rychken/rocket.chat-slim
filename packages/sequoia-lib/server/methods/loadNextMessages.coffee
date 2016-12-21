Meteor.methods
	loadNextMessages: (rid, end, limit=20) ->

		check rid, String
		# check end, Match.Optional(Number)
		check limit, Number

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'loadNextMessages' }

		fromId = Meteor.userId()

		unless Meteor.call 'canAccessRoom', rid, fromId
			return false

		options =
			sort:
				ts: 1
			limit: limit

		if not Sequoia.settings.get 'Message_ShowEditedStatus'
			options.fields = { 'editedAt': 0 }

		if end?
			records = Sequoia.models.Messages.findVisibleByRoomIdAfterTimestamp(rid, end, options).fetch()
		else
			records = Sequoia.models.Messages.findVisibleByRoomId(rid, options).fetch()

		messages = _.map records, (message) ->
			message.starred = _.findWhere message.starred, { _id: fromId }
			return message

		return {
			messages: messages
		}
