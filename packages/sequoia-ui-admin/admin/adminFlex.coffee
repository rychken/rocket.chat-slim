Template.adminFlex.onCreated ->
	if not Sequoia.settings.cachedCollectionPrivate?
		Sequoia.settings.cachedCollectionPrivate = new Sequoia.CachedCollection({ name: 'private-settings', eventType: 'onAll' })
		Sequoia.settings.collectionPrivate = Sequoia.settings.cachedCollectionPrivate.collection
		Sequoia.settings.cachedCollectionPrivate.init()


Template.adminFlex.helpers
	groups: ->
		return Sequoia.settings.collectionPrivate.find({type: 'group'}, { sort: { sort: 1, i18nLabel: 1 } }).fetch()
	label: ->
		return TAPi18n.__(@i18nLabel or @_id)
	adminBoxOptions: ->
		return Sequoia.AdminBox.getOptions()


Template.adminFlex.events
	'mouseenter header': ->
		SideNav.overArrow()

	'mouseleave header': ->
		SideNav.leaveArrow()

	'click header': ->
		SideNav.closeFlex()

	'click .cancel-settings': ->
		SideNav.closeFlex()

	'click .admin-link': ->
		menu.close()
