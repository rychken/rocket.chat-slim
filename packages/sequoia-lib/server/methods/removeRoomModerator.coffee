Meteor.methods
	removeRoomModerator: (rid, userId) ->

		check rid, String
		check userId, String

		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeRoomModerator' }

		unless Sequoia.authz.hasPermission Meteor.userId(), 'set-moderator', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeRoomModerator' }

		subscription = Sequoia.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'removeRoomModerator' }

		Sequoia.models.Subscriptions.removeRoleById(subscription._id, 'moderator')

		user = Sequoia.models.Users.findOneById userId
		fromUser = Sequoia.models.Users.findOneById Meteor.userId()
		Sequoia.models.Messages.createSubscriptionRoleRemovedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'moderator'

		if Sequoia.settings.get('UI_DisplayRoles')
			Sequoia.Notifications.notifyAll('roles-change', { type: 'removed', _id: 'moderator', u: { _id: user._id, username: user.username }, scope: rid });

		return true
