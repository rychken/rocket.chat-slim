Meteor.methods
	setUserActiveStatus: (userId, active) ->

		check userId, String
		check active, Boolean

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'setUserActiveStatus' }

		unless Sequoia.authz.hasPermission( Meteor.userId(), 'edit-other-user-active-status') is true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'setUserActiveStatus' }

		user = Sequoia.models.Users.findOneById userId

		Sequoia.models.Users.setUserActive userId, active
		Sequoia.models.Subscriptions.setArchivedByUsername user?.username, !active

		if active is false
			Sequoia.models.Users.unsetLoginTokens userId

		return true
