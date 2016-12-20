Meteor.methods
	addRoomModerator: (rid, userId) ->

		check rid, String
		check userId, String

		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'addRoomModerator' }

		unless Sequoia.authz.hasPermission Meteor.userId(), 'set-moderator', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'addRoomModerator' }

		subscription = Sequoia.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'addRoomModerator' }

		Sequoia.models.Subscriptions.addRoleById(subscription._id, 'moderator')

		user = Sequoia.models.Users.findOneById userId
		fromUser = Sequoia.models.Users.findOneById Meteor.userId()
		Sequoia.models.Messages.createSubscriptionRoleAddedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'moderator'

		if Sequoia.settings.get('UI_DisplayRoles')
			Sequoia.Notifications.notifyAll('roles-change', { type: 'added', _id: 'moderator', u: { _id: user._id, username: user.username }, scope: rid });

		return true
