Package.describe({
	name: 'sequoia:migrations',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use('sequoia:lib');
	api.use('sequoia:version');
	api.use('ecmascript');
	api.use('coffeescript');
	api.use('underscore');
	api.use('check');
	api.use('mongo');
	api.use('momentjs:moment');

	api.addFiles([
		'methods/migrate.coffee',
		'migrations.js',
		'xrun.coffee',
	], 'server');
});
