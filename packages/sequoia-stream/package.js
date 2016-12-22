Package.describe({
	name: 'sequoia:stream',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'rocketchat:streamer',
	]);

	api.addFiles([
		'messages.coffee',
		'streamBroadcast.coffee',
	], 'server');

});
