/* globals Sequoia */
Sequoia.deleteUser = function(userId) {
	const user = Sequoia.models.Users.findOneById(userId);

	Sequoia.models.Messages.removeByUserId(userId); // Remove user messages
	Sequoia.models.Subscriptions.findByUserId(userId).forEach((subscription) => {
		let room = Sequoia.models.Rooms.findOneById(subscription.rid);
		if (room) {
			if (room.t !== 'c' && room.usernames.length === 1) {
				Sequoia.models.Rooms.removeById(subscription.rid); // Remove non-channel rooms with only 1 user (the one being deleted)
			}
			if (room.t === 'd') {
				Sequoia.models.Subscriptions.removeByRoomId(subscription.rid);
				Sequoia.models.Messages.removeByRoomId(subscription.rid);
			}
		}
	});

	Sequoia.models.Subscriptions.removeByUserId(userId); // Remove user subscriptions
	Sequoia.models.Rooms.removeByTypeContainingUsername('d', user.username); // Remove direct rooms with the user
	Sequoia.models.Rooms.removeUsernameFromAll(user.username); // Remove user from all other rooms

	// removes user's avatar
	if (user.avatarOrigin === 'upload' || user.avatarOrigin === 'url') {
		SequoiaFileAvatarInstance.deleteFile(encodeURIComponent(user.username + '.jpg'));
	}

	Sequoia.models.Users.removeById(userId); // Remove user from users database
};
