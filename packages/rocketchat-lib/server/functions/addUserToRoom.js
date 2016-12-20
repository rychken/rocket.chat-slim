Sequoia.addUserToRoom = function(rid, user, inviter, silenced) {
	let now = new Date();
	let room = Sequoia.models.Rooms.findOneById(rid);

	// Check if user is already in room
	let subscription = Sequoia.models.Subscriptions.findOneByRoomIdAndUserId(rid, user._id);
	if (subscription) {
		return;
	}

	if (room.t === 'c') {
		Sequoia.callbacks.run('beforeJoinRoom', user, room);
	}

	var muted = room.ro && !Sequoia.authz.hasPermission(user._id, 'post-readonly');
	Sequoia.models.Rooms.addUsernameById(rid, user.username, muted);
	Sequoia.models.Subscriptions.createWithRoomAndUser(room, user, {
		ts: now,
		open: true,
		alert: true,
		unread: 1
	});

	if (!silenced) {
		if (inviter) {
			Sequoia.models.Messages.createUserAddedWithRoomIdAndUser(rid, user, {
				ts: now,
				u: {
					_id: inviter._id,
					username: inviter.username
				}
			});
		} else {
			Sequoia.models.Messages.createUserJoinWithRoomIdAndUser(rid, user, { ts: now });
		}
	}

	if (room.t === 'c') {
		Meteor.defer(function() {
			Sequoia.callbacks.run('afterJoinRoom', user, room);
		});
	}

	return true;
};
