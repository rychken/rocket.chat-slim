Meteor.methods
	hideRoom: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'hideRoom' }

		Sequoia.models.Subscriptions.hideByRoomIdAndUserId rid, Meteor.userId()
