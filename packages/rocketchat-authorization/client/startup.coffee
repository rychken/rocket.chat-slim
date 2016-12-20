Meteor.subscribe 'roles'

Sequoia.AdminBox.addOption
	href: 'admin-permissions'
	i18nLabel: 'Permissions'
	permissionGranted: ->
		return Sequoia.authz.hasAllPermission('access-permissions')
