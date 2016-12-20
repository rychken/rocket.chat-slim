Package.describe({
	name: 'sequoia:error-handler',
	version: '1.0.0',
	summary: 'Rocket.Chat Error Handler',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'ecmascript',
		'sequoia:lib',
		'templating'
	]);

	api.addFiles('server/lib/Sequoia.ErrorHandler.js', 'server');
	api.addFiles('server/startup/settings.js', 'server');
});
