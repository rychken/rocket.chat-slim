Package.describe({
	name: 'sequoia:cors',
	version: '0.0.1',
	summary: 'Enable CORS',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'webapp'
	]);

	api.addFiles('cors.coffee', 'server');
	api.addFiles('common.coffee');
});
