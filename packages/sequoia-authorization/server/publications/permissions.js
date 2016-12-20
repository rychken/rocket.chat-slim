Meteor.methods({
	'permissions/get'(updatedAt) {
		this.unblock();

		if (updatedAt instanceof Date) {
			return Sequoia.models.Permissions.dinamicFindChangesAfter('find', updatedAt);
		}

		return Sequoia.models.Permissions.find().fetch();
	}
});


Sequoia.models.Permissions.on('change', (type, ...args) => {
	const records = Sequoia.models.Permissions.getChangedRecords(type, args[0]);

	for (const record of records) {
		Sequoia.Notifications.notifyAll('permissions-changed', type, record);
	}
});
