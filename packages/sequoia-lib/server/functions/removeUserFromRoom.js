Sequoia.removeUserFromRoom = function(rid, user) {
	let room = Sequoia.models.Rooms.findOneById(rid);

	if (room) {
		Sequoia.callbacks.run('beforeLeaveRoom', user, room);
		Sequoia.models.Rooms.removeUsernameById(rid, user.username);

		if (room.usernames.indexOf(user.username) !== -1) {
			let removedUser = user;
			Sequoia.models.Messages.createUserLeaveWithRoomIdAndUser(rid, removedUser);
		}

		if (room.t === 'l') {
			Sequoia.models.Messages.createCommandWithRoomIdAndUser('survey', rid, user);
		}

		Sequoia.models.Subscriptions.removeByRoomIdAndUserId(rid, user._id);

		Meteor.defer(function() {
			Sequoia.callbacks.run('afterLeaveRoom', user, room);
		});
	}
};
