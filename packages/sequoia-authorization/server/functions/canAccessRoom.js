/* globals Sequoia */
Sequoia.authz.roomAccessValidators = [
	function(room, user) {
		return room.usernames.indexOf(user.username) !== -1;
	},
	function(room, user) {
		if (room.t === 'c') {
			return Sequoia.authz.hasPermission(user._id, 'view-c-room');
		}
	}
];

Sequoia.authz.canAccessRoom = function(room, user) {
	return Sequoia.authz.roomAccessValidators.some((validator) => {
		return validator.call(this, room, user);
	});
};

Sequoia.authz.addRoomAccessValidator = function(validator) {
	Sequoia.authz.roomAccessValidators.push(validator);
};
