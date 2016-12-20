Package.describe({
	name: 'sequoia:file',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use('sequoia:lib');
	api.use('sequoia:version');
	api.use('coffeescript');

	api.addFiles('file.server.coffee', 'server');

	api.export('SequoiaFile', 'server');
});

Npm.depends({
	'mkdirp': '0.5.1',
	'gridfs-stream': '1.1.1',
	'gm': '1.23.0'
});
