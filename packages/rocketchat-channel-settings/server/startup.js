Meteor.startup(function() {
	Sequoia.models.Permissions.upsert('post-readonly', {$set: { roles: ['admin', 'owner', 'moderator'] } });
	Sequoia.models.Permissions.upsert('set-readonly', {$set: { roles: ['admin', 'owner'] } });
});
