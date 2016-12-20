Meteor.methods
	registerUser: (formData) ->

		check formData, Object

		if Sequoia.settings.get('Accounts_RegistrationForm') is 'Disabled'
			throw new Meteor.Error 'error-user-registration-disabled', 'User registration is disabled', { method: 'registerUser' }

		else if Sequoia.settings.get('Accounts_RegistrationForm') is 'Secret URL' and (not formData.secretURL or formData.secretURL isnt Sequoia.settings.get('Accounts_RegistrationForm_SecretURL'))
			throw new Meteor.Error 'error-user-registration-secret', 'User registration is only allowed via Secret URL', { method: 'registerUser' }

		Sequoia.validateEmailDomain(formData.email);

		userData =
			email: s.trim(formData.email.toLowerCase())
			password: formData.pass

		# Check if user has already been imported and never logged in. If so, set password and let it through
		importedUser = Sequoia.models.Users.findOneByEmailAddress s.trim(formData.email.toLowerCase())
		if importedUser?.importIds?.length and !importedUser.lastLogin
			Accounts.setPassword(importedUser._id, userData.password)
			userId = importedUser._id
		else
			userId = Accounts.createUser userData

		Sequoia.models.Users.setName userId, s.trim(formData.name)

		Sequoia.saveCustomFields(userId, formData)

		try
			if userData.email
				Accounts.sendVerificationEmail(userId, userData.email);
		catch error
			# throw new Meteor.Error 'error-email-send-failed', 'Error trying to send email: ' + error.message, { method: 'registerUser', message: error.message }

		return userId
