Package.describe({
	name: 'sequoia:action-links',
	version: '0.0.1',
	summary: 'Add custom actions that call functions',
	git: ''
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('templating');
	api.use('sequoia:lib');
	api.use('sequoia:theme');
	api.use('sequoia:ui');

	api.addFiles('client/init.js', 'client');
	api.addAssets('client/stylesheets/actionLinks.less', 'server');
	api.addFiles('loadStylesheets.js', 'server');

	api.addFiles('server/registerActionLinkFuncts.js', ['server', 'client']);
	api.addFiles('server/actionLinkHandler.js', ['server', 'client']);

});
