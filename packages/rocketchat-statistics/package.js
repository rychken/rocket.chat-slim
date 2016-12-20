Package.describe({
	name: 'sequoia:statistics',
	version: '0.0.1',
	summary: 'Statistics generator',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'sequoia:lib'
	]);

	// Statistics
	api.addFiles('lib/sequoia.coffee', [ 'client', 'server' ]);
	api.addFiles([
		'server/models/Statistics.coffee',
		'server/functions/get.coffee',
		'server/functions/save.coffee',
		'server/methods/getStatistics.coffee'
	], 'server');
});
