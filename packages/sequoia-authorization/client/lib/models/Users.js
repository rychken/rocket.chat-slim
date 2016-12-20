if (_.isUndefined(Sequoia.models.Users)) {
	Sequoia.models.Users = {};
}

Sequoia.models.Users.isUserInRole = function(userId, roleName) {
	var query = {
		_id: userId,
		roles: roleName
	};

	return !_.isUndefined(this.findOne(query));
};

Sequoia.models.Users.findUsersInRoles = function(roles, scope, options) {
	roles = [].concat(roles);

	var query = {
		roles: { $in: roles }
	};

	return this.find(query, options);
};
