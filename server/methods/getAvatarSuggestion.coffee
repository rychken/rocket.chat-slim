@getAvatarSuggestionForUser = (user) ->

	check user, Object

	avatars = []

	if user.emails?.length > 0
		for email in user.emails when email.verified is true
			avatars.push
				service: 'gravatar'
				url: Gravatar.imageUrl(email.address, {default: '404', size: 200, secure: true})

		for email in user.emails when email.verified isnt true
			avatars.push
				service: 'gravatar'
				url: Gravatar.imageUrl(email.address, {default: '404', size: 200, secure: true})

	validAvatars = {}
	for avatar in avatars
		try
			result = HTTP.get avatar.url, npmRequestOptions: {encoding: 'binary'}
			if result.statusCode is 200
				blob = "data:#{result.headers['content-type']};base64,"
				blob += Buffer(result.content, 'binary').toString('base64')
				avatar.blob = blob
				avatar.contentType = result.headers['content-type']
				validAvatars[avatar.service] = avatar
		catch e
			# ...

	return validAvatars


Meteor.methods
	getAvatarSuggestion: ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getAvatarSuggestion' }

		@unblock()

		user = Meteor.user()

		getAvatarSuggestionForUser user
