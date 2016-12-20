Meteor.methods
	'public-settings/get': (updatedAt) ->
		this.unblock()

		if updatedAt instanceof Date
			result =
				update: Sequoia.models.Settings.findNotHiddenPublicUpdatedAfter(updatedAt).fetch()
				remove: Sequoia.models.Settings.trashFindDeletedAfter(updatedAt, {hidden: { $ne: true }, public: true}, {fields: {_id: 1, _deletedAt: 1}}).fetch()

			return result

		return Sequoia.models.Settings.findNotHiddenPublic().fetch()

	'private-settings/get': (updatedAt) ->
		unless Meteor.userId()
			return []

		this.unblock()

		if not Sequoia.authz.hasPermission Meteor.userId(), 'view-privileged-setting'
			return []

		if updatedAt instanceof Date
			return Sequoia.models.Settings.dinamicFindChangesAfter('findNotHidden', updatedAt);

		return Sequoia.models.Settings.findNotHidden().fetch()


Sequoia.models.Settings.on 'change', (type, args...) ->
	records = Sequoia.models.Settings.getChangedRecords type, args[0]

	for record in records
		if record.public is true
			Sequoia.Notifications.notifyAll 'public-settings-changed', type, _.pick(record, '_id', 'value')

		Sequoia.Notifications.notifyAll 'private-settings-changed', type, record


Sequoia.Notifications.streamAll.allowRead 'private-settings-changed', ->
	if not @userId? then return false

	return Sequoia.authz.hasPermission @userId, 'view-privileged-setting'
