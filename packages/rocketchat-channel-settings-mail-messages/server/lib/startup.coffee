Meteor.startup ->
	permission = { _id: 'mail-messages', roles : [ 'admin' ] }
	Sequoia.models.Permissions.upsert( permission._id, { $setOnInsert : permission })
