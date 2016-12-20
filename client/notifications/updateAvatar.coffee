Meteor.startup ->
	Sequoia.Notifications.onAll 'updateAvatar', (data) ->
		updateAvatarOfUsername data.username
