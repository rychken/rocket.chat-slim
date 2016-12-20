Package.describe({
	name: 'sequoia:markdown',
	version: '0.0.1',
	summary: 'Message pre-processor that will process selected markdown notations',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'templating',
		'underscorestring:underscore.string',
		'simple:highlight.js',
		'sequoia:lib'
	]);

	api.addFiles('settings.coffee', 'server');
	api.addFiles('markdown.coffee');
	api.addFiles('markdowncode.coffee');
});

Package.onTest(function(api) {
	api.use([
		'coffeescript',
		'sanjo:jasmine@0.20.2',
		'sequoia:lib',
		'sequoia:markdown'
	]);

	api.addFiles('tests/jasmine/client/unit/markdown.spec.coffee', 'client');
});
