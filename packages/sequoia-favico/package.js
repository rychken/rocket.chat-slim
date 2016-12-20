Package.describe({
	name: 'sequoia:favico',
	version: '0.0.1',
	summary: 'Favico.js for Rocket.Chat'
});

Package.onUse(function(api) {
	api.use([
		'coffeescript'
	], 'client');
	api.addFiles([
		'favico.js'
	], 'client');
});
