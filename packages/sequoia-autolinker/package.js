Package.describe({
	name: 'sequoia:autolinker',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate links on messages',
	git: ''
});

Npm.depends({
	autolinker: '1.2.0'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('sequoia:lib');

	api.addFiles('client.js', 'client');

	api.addFiles('settings.js', 'server');
});
