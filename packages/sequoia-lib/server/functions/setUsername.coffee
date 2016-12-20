Sequoia._setUsername = (userId, username) ->
	username = s.trim username
	if not userId or not username
		return false

	try
		nameValidation = new RegExp '^' + Sequoia.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test username
		return false

	user = Sequoia.models.Users.findOneById userId

	# User already has desired username, return
	if user.username is username
		return user

	previousUsername = user.username

	# Check username availability or if the user already owns a different casing of the name
	if ( !previousUsername or !(username.toLowerCase() == previousUsername.toLowerCase()))
		unless Sequoia.checkUsernameAvailability username
			return false



	# If first time setting username, send Enrollment Email
	try
		if not previousUsername and user.emails?.length > 0 and Sequoia.settings.get 'Accounts_Enrollment_Email'
			Accounts.sendEnrollmentEmail(user._id)
	catch error

	# Username is available; if coming from old username, update all references
	if previousUsername
		Sequoia.models.Messages.updateAllUsernamesByUserId user._id, username
		Sequoia.models.Messages.updateUsernameOfEditByUserId user._id, username

		Sequoia.models.Messages.findByMention(previousUsername).forEach (msg) ->
			updatedMsg = msg.msg.replace(new RegExp("@#{previousUsername}", "ig"), "@#{username}")
			Sequoia.models.Messages.updateUsernameAndMessageOfMentionByIdAndOldUsername msg._id, previousUsername, username, updatedMsg

		Sequoia.models.Rooms.replaceUsername previousUsername, username
		Sequoia.models.Rooms.replaceMutedUsername previousUsername, username
		Sequoia.models.Rooms.replaceUsernameOfUserByUserId user._id, username

		Sequoia.models.Subscriptions.setUserUsernameByUserId user._id, username
		Sequoia.models.Subscriptions.setNameForDirectRoomsWithOldName previousUsername, username

		rs = SequoiaFileAvatarInstance.getFileWithReadStream(encodeURIComponent("#{previousUsername}.jpg"))
		if rs?
			SequoiaFileAvatarInstance.deleteFile encodeURIComponent("#{username}.jpg")
			ws = SequoiaFileAvatarInstance.createWriteStream encodeURIComponent("#{username}.jpg"), rs.contentType
			ws.on 'end', Meteor.bindEnvironment ->
				SequoiaFileAvatarInstance.deleteFile encodeURIComponent("#{previousUsername}.jpg")
			rs.readStream.pipe(ws)

	# Set new username
	Sequoia.models.Users.setUsername user._id, username
	user.username = username
	return user

Sequoia.setUsername = Sequoia.RateLimiter.limitFunction Sequoia._setUsername, 1, 60000,
	0: (userId) -> return not userId or not Sequoia.authz.hasPermission(userId, 'edit-other-user-info') # Administrators have permission to change others usernames, so don't limit those
