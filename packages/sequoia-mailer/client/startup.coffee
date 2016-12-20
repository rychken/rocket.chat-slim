Sequoia.AdminBox.addOption
	href: 'mailer'
	i18nLabel: 'Mailer'
	permissionGranted: ->
		return Sequoia.authz.hasAllPermission('access-mailer')
