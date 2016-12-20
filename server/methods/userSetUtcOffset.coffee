Meteor.methods
	userSetUtcOffset: (utcOffset) ->

		check utcOffset, Number

		if not @userId?
			return

		@unblock()

		Sequoia.models.Users.setUtcOffset @userId, utcOffset

DDPRateLimiter.addRule
	type: 'method'
	name: 'userSetUtcOffset'
	userId: -> return true
, 1, 60000
