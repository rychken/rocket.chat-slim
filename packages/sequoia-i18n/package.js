Package.describe({
	name: 'sequoia:i18n',
	version: '0.0.1',
	summary: 'Sequoia i18n',
	git: ''
});

Package.onUse(function(api) {
	api.use('templating', 'client');

	var fs = Npm.require('fs');
	fs.readdirSync('packages/sequoia-i18n/i18n').forEach(function(filename) {
		if (filename.indexOf('.json') > -1 && fs.statSync('packages/sequoia-i18n/i18n/' + filename).size > 16) {
			api.addFiles('i18n/' + filename);
		}
	});

	api.use('tap:i18n@1.8.2');
});
