Sequoia.addUserToDefaultChannels = function(user, silenced) {
	Sequoia.callbacks.run('beforeJoinDefaultChannels', user);
	let defaultRooms = Sequoia.models.Rooms.findByDefaultAndTypes(true, ['c', 'p'], {fields: {usernames: 0}}).fetch();
	defaultRooms.forEach((room) => {

		// put user in default rooms
		let muted = room.ro && !Sequoia.authz.hasPermission(user._id, 'post-readonly');
		Sequoia.models.Rooms.addUsernameById(room._id, user.username, muted);

		if (!Sequoia.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)) {

			// Add a subscription to this user
			Sequoia.models.Subscriptions.createWithRoomAndUser(room, user, {
				ts: new Date(),
				open: true,
				alert: true,
				unread: 1
			});

			// Insert user joined message
			if (!silenced) {
				Sequoia.models.Messages.createUserJoinWithRoomIdAndUser(room._id, user);
			}
		}
	});
};
