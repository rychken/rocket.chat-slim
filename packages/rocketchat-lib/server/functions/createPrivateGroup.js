/* globals Sequoia */
Sequoia.createPrivateGroup = function(name, owner, members) {
	name = s.trim(name);
	owner = s.trim(owner);
	members = [].concat(members);

	if (!name) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'Sequoia.createPrivateGroup' });
	}

	if (!owner) {
		throw new Meteor.Error('error-invalid-user', 'Invalid user', { function: 'Sequoia.createPrivateGroup' });
	}

	let nameValidation;
	try {
		nameValidation = new RegExp('^' + Sequoia.settings.get('UTF8_Names_Validation') + '$');
	} catch (error) {
		nameValidation = new RegExp('^[0-9a-zA-Z-_.]+$');
	}

	if (!nameValidation.test(name)) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'Sequoia.createPrivateGroup' });
	}

	let now = new Date();
	if (!_.contains(members, owner)) {
		members.push(owner);
	}

	// avoid duplicate names
	let room = Sequoia.models.Rooms.findOneByName(name);
	if (room) {
		if (room.archived) {
			throw new Meteor.Error('error-archived-duplicate-name', 'There\'s an archived channel with name ' + name, { function: 'Sequoia.createPrivateGroup', room_name: name });
		} else {
			throw new Meteor.Error('error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'Sequoia.createPrivateGroup', room_name: name });
		}
	}

	room = Sequoia.models.Rooms.createWithTypeNameUserAndUsernames('p', name, owner, members, { ts: now });

	for (let username of members) {
		let member = Sequoia.models.Users.findOneByUsername(username, { fields: { username: 1 }});
		if (!member) {
			continue;
		}

		let extra = { open: true };

		if (username === owner) {
			extra.ls = now;
		}

		Sequoia.models.Subscriptions.createWithRoomAndUser(room, member, extra);
	}

	// set owner
	owner = Sequoia.models.Users.findOneByUsername(owner, { fields: { username: 1 }});
	Sequoia.authz.addUserRoles(owner._id, ['owner'], room._id);

	return {
		rid: room._id
	};
};
