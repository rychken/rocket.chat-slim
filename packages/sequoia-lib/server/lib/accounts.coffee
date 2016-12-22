# Deny Account.createUser in client and set Meteor.loginTokenExpires
accountsConfig = { forbidClientAccountCreation: true, loginExpirationInDays: Sequoia.settings.get 'Accounts_LoginExpiration' }
Accounts.config accountsConfig

Accounts.emailTemplates.siteName = Sequoia.settings.get 'Site_Name';
Accounts.emailTemplates.from = "#{Sequoia.settings.get 'Site_Name'} <#{Sequoia.settings.get 'From_Email'}>";

verifyEmailHtml = Accounts.emailTemplates.verifyEmail.text
Accounts.emailTemplates.verifyEmail.html = (user, url) ->
	url = url.replace Meteor.absoluteUrl(), Meteor.absoluteUrl() + 'login/'
	verifyEmailHtml user, url

resetPasswordHtml = Accounts.emailTemplates.resetPassword.text
Accounts.emailTemplates.resetPassword.html = (user, url) ->
	url = url.replace /\/#\//, '/'
	resetPasswordHtml user, url

Accounts.emailTemplates.enrollAccount.subject = (user) ->
	if Sequoia.settings.get 'Accounts_Enrollment_Customized'
		subject = Sequoia.settings.get 'Accounts_Enrollment_Email_Subject'
	else
		subject = TAPi18n.__('Accounts_Enrollment_Email_Subject_Default', { lng: user?.language || Sequoia.settings.get('language') || 'en' })

	return Sequoia.placeholders.replace(subject);

Accounts.emailTemplates.enrollAccount.html = (user, url) ->

	if Sequoia.settings.get 'Accounts_Enrollment_Customized'
		html = Sequoia.settings.get 'Accounts_Enrollment_Email'
	else
		html = TAPi18n.__('Accounts_Enrollment_Email_Default', { lng: user?.language || Sequoia.settings.get('language') || 'en' })

	header = Sequoia.placeholders.replace(Sequoia.settings.get('Email_Header') || "")
	footer = Sequoia.placeholders.replace(Sequoia.settings.get('Email_Footer') || "")
	html = Sequoia.placeholders.replace(html, {
		name: user.name,
		email: user.emails?[0]?.address
	});

	return header + html + footer;

Accounts.onCreateUser (options, user) ->
	# console.log 'onCreateUser ->',JSON.stringify arguments, null, '  '
	# console.log 'options ->',JSON.stringify options, null, '  '
	# console.log 'user ->',JSON.stringify user, null, '  '

	Sequoia.callbacks.run 'beforeCreateUser', options, user

	user.status = 'offline'
	user.active = not Sequoia.settings.get 'Accounts_ManuallyApproveNewUsers'

	if not user?.name? or user.name is ''
		if options.profile?.name?
			user.name = options.profile?.name

	if user.services?
		for serviceName, service of user.services
			if not user?.name? or user.name is ''
				if service.name?
					user.name = service.name
				else if service.username?
					user.name = service.username

			if not user.emails? and service.email?
				user.emails = [
					address: service.email
					verified: true
				]

	return user

# Wrap insertUserDoc to allow executing code after Accounts.insertUserDoc is run
Accounts.insertUserDoc = _.wrap Accounts.insertUserDoc, (insertUserDoc, options, user) ->
	roles = []
	if Match.test(user.globalRoles, [String]) and user.globalRoles.length > 0
		roles = roles.concat user.globalRoles

	delete user.globalRoles

	user.type ?= 'user'

	_id = insertUserDoc.call(Accounts, options, user)

	if roles.length is 0
		# when inserting first user give them admin privileges otherwise make a regular user
		hasAdmin = Sequoia.models.Users.findOne({ roles: 'admin' }, {fields: {_id: 1}})
		if hasAdmin?
			roles.push 'user'
		else
			roles.push 'admin'

	Sequoia.authz.addUserRoles(_id, roles)

	Meteor.defer ->
		Sequoia.callbacks.run 'afterCreateUser', options, user

	return _id

Accounts.validateLoginAttempt (login) ->
	login = Sequoia.callbacks.run 'beforeValidateLogin', login

	if login.allowed isnt true
		return login.allowed

	# bypass for livechat users
	if login.user.type is 'visitor'
		return true

	if !!login.user?.active isnt true
		throw new Meteor.Error 'error-user-is-not-activated', 'User is not activated', { function: 'Accounts.validateLoginAttempt' }
		return false

	# If user is admin, no need to check if email is verified
	if 'admin' not in login.user?.roles and login.type is 'password' and Sequoia.settings.get('Accounts_EmailVerification') is true
		validEmail = login.user.emails.filter (email) ->
			return email.verified is true

		if validEmail.length is 0
			throw new Meteor.Error 'error-invalid-email', 'Invalid email __email__'
			return false

	Sequoia.models.Users.updateLastLoginById login.user._id

	Meteor.defer ->
		Sequoia.callbacks.run 'afterValidateLogin', login

	return true

Accounts.validateNewUser (user) ->
	# bypass for livechat users
	if user.type is 'visitor'
		return true

	if Sequoia.settings.get('Accounts_Registration_AuthenticationServices_Enabled') is false and Sequoia.settings.get('LDAP_Enable') is false and not user.services?.password?
		throw new Meteor.Error 'registration-disabled-authentication-services', 'User registration is disabled for authentication services'
	return true


Accounts.validateNewUser (user) ->
	# bypass for livechat users
	if user.type is 'visitor'
		return true

	domainWhiteList = Sequoia.settings.get('Accounts_AllowedDomainsList')

	if _.isEmpty s.trim(domainWhiteList)
		return true

	domainWhiteList = _.map(domainWhiteList.split(','), (domain) -> domain.trim())

	if user.emails?.length > 0
		ret = false
		email = user.emails[0].address
		for domain in domainWhiteList
			if email.match('@' + RegExp.escape(domain) + '$')
				ret = true
				break

		if not ret
			throw new Meteor.Error 'error-invalid-domain'

	return true
