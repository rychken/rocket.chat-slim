Package.describe({
	name: 'sequoia:sandstorm',
	version: '0.0.1',
	summary: 'Sandstorm integeration for Rocket.Chat',
	git: ''
});

Package.onUse(function(api) {
	api.use([ 'ecmascript', 'sequoia:lib' ]);

	api.addFiles([ 'server/lib.js', 'server/events.js', 'server/powerbox.js' ], 'server');
	api.addFiles([ 'client/powerboxListener.js' ], 'client');
});
