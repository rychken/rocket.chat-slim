Package.describe({
	name: 'sequoia:tooltip',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('templating', 'client');
	api.use('sequoia:lib');
	api.use('sequoia:theme');
	api.use('sequoia:ui-master');

	api.addAssets('tooltip.less', 'server');
	api.addFiles('loadStylesheet.js', 'server');

	api.addFiles('sequoia-tooltip.html', 'client');
	api.addFiles('sequoia-tooltip.js', 'client');

	api.addFiles('init.js', 'client');
});
