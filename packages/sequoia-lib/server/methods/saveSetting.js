Meteor.methods({
	saveSetting: function(_id, value) {
		if (Meteor.userId() === null) {
			throw new Meteor.Error('error-action-not-allowed', 'Editing settings is not allowed', {
				method: 'saveSetting'
			});
		}

		if (!Sequoia.authz.hasPermission(Meteor.userId(), 'edit-privileged-setting')) {
			throw new Meteor.Error('error-action-not-allowed', 'Editing settings is not allowed', {
				method: 'saveSetting'
			});
		}

		//Verify the _id passed in is a string.
		check(_id, String);

		const setting = Sequoia.models.Settings.findOneById(_id);

		//Verify the value is what it should be
		switch (setting.type) {
			case 'roomPick':
				check(value, [Object]);
				break;
			case 'boolean':
				check(value, Boolean);
				break;
			case 'int':
				check(value, Number);
				break;
			default:
				check(value, String);
				break;
		}

		Sequoia.settings.updateById(_id, value);
		return true;
	}
});
