Sequoia.statistics.get = ->
	statistics = {}

	# Version
	statistics.uniqueId = Sequoia.settings.get("uniqueID")
	statistics.installedAt = Sequoia.models.Settings.findOne("uniqueID")?.createdAt
	statistics.version = Sequoia.Info?.version
	statistics.tag = Sequoia.Info?.tag
	statistics.branch = Sequoia.Info?.branch

	# User statistics
	statistics.totalUsers = Meteor.users.find().count()
	statistics.activeUsers = Meteor.users.find({ active: true }).count()
	statistics.nonActiveUsers = statistics.totalUsers - statistics.activeUsers
	statistics.onlineUsers = Meteor.users.find({ statusConnection: 'online' }).count()
	statistics.awayUsers = Meteor.users.find({ statusConnection: 'away' }).count()
	statistics.offlineUsers = statistics.totalUsers - statistics.onlineUsers - statistics.awayUsers

	# Room statistics
	statistics.totalRooms = Sequoia.models.Rooms.find().count()
	statistics.totalChannels = Sequoia.models.Rooms.findByType('c').count()
	statistics.totalPrivateGroups = Sequoia.models.Rooms.findByType('p').count()
	statistics.totalDirect = Sequoia.models.Rooms.findByType('d').count()

	# Message statistics
	statistics.totalMessages = Sequoia.models.Messages.find().count()

	statistics.lastLogin = Sequoia.models.Users.getLastLogin()
	statistics.lastMessageSentAt = Sequoia.models.Messages.getLastTimestamp()
	statistics.lastSeenSubscription = Sequoia.models.Subscriptions.getLastSeen()

	migration = Migrations?._getControl()
	if migration
		statistics.migration = _.pick(migration, 'version', 'locked')

	os = Npm.require('os')
	statistics.os =
		type: os.type()
		platform: os.platform()
		arch: os.arch()
		release: os.release()
		uptime: os.uptime()
		loadavg: os.loadavg()
		totalmem: os.totalmem()
		freemem: os.freemem()
		cpus: os.cpus()

	statistics.process =
		nodeVersion: process.version
		pid: process.pid
		uptime: process.uptime()

	statistics.migration = Sequoia.Migrations._getControl()

	statistics.instanceCount = InstanceStatus.getCollection().find().count()

	return statistics
