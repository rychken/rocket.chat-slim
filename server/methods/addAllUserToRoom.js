Meteor.methods({
	addAllUserToRoom: function(rid) {

		check (rid, String);

		if (Sequoia.authz.hasRole(this.userId, 'admin') === true) {
			var now, room, users;
			var userCount = Sequoia.models.Users.find().count();
			if (userCount > Sequoia.settings.get('API_User_Limit')) {
				throw new Meteor.Error('error-user-limit-exceeded', 'User Limit Exceeded', {
					method: 'addAllToRoom'
				});
			}
			room = Sequoia.models.Rooms.findOneById(rid);
			if (room == null) {
				throw new Meteor.Error('error-invalid-room', 'Invalid room', {
					method: 'addAllToRoom'
				});
			}
			users = Sequoia.models.Users.find().fetch();
			now = new Date();
			users.forEach(function(user) {
				var subscription;
				subscription = Sequoia.models.Subscriptions.findOneByRoomIdAndUserId(rid, user._id);
				if (subscription != null) {
					return;
				}
				Sequoia.callbacks.run('beforeJoinRoom', user, room);
				Sequoia.models.Rooms.addUsernameById(rid, user.username);
				Sequoia.models.Subscriptions.createWithRoomAndUser(room, user, {
					ts: now,
					open: true,
					alert: true,
					unread: 1
				});
				Sequoia.models.Messages.createUserJoinWithRoomIdAndUser(rid, user, {
					ts: now
				});
				Meteor.defer(function() {});
				return Sequoia.callbacks.run('afterJoinRoom', user, room);
			});
			return true;
		} else {
			throw (new Meteor.Error(403, 'Access to Method Forbidden', {
				method: 'addAllToRoom'
			}));
		}
	}
});
