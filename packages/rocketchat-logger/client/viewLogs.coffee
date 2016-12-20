@stdout = new Meteor.Collection 'stdout'

Meteor.startup ->
	Sequoia.AdminBox.addOption
		href: 'admin-view-logs'
		i18nLabel: 'View_Logs'
		permissionGranted: ->
			return Sequoia.authz.hasAllPermission('view-logs')

FlowRouter.route '/admin/view-logs',
	name: 'admin-view-logs'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('View_Logs')
			pageTemplate: 'viewLogs'
			noScroll: true
