Meteor.methods
	logoutCleanUp: (user) ->

		check user, Object

		Meteor.defer ->

			Sequoia.callbacks.run 'afterLogoutCleanUp', user
