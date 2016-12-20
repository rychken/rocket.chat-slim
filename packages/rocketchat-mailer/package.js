Package.describe({
	name: 'sequoia:mailer',
	version: '0.0.1',
	summary: 'Mailer for Rocket.Chat'
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'ddp-rate-limiter',
		'kadira:flow-router',
		'sequoia:lib',
		'sequoia:authorization'
	]);

	api.use('templating', 'client');

	api.addFiles('lib/Mailer.coffee');

	api.addFiles([
		'client/startup.coffee',
		'client/router.coffee',
		'client/views/mailer.html',
		'client/views/mailer.coffee',
		'client/views/mailerUnsubscribe.html',
		'client/views/mailerUnsubscribe.coffee'
	], 'client');

	api.addFiles([
		'server/startup.coffee',
		'server/models/Users.coffee',
		'server/functions/sendMail.coffee',
		'server/functions/unsubscribe.coffee',
		'server/methods/sendMail.coffee',
		'server/methods/unsubscribe.coffee'
	], 'server');

	api.export('Mailer');
});
