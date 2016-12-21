Meteor.methods
	resetAvatar:->
		unless Meteor.userId()
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'resetAvatar' });

		unless Sequoia.settings.get("Accounts_AllowUserAvatarChange")
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'resetAvatar' });

		user = Meteor.user()

		SequoiaFileAvatarInstance.deleteFile "#{user.username}.jpg"

		Sequoia.models.Users.unsetAvatarOrigin user._id

		Sequoia.Notifications.notifyAll 'updateAvatar', {username: user.username}
		return

# Limit changing avatar once per minute
DDPRateLimiter.addRule
	type: 'method'
	name: 'resetAvatar'
	userId: -> return true
, 1, 60000
