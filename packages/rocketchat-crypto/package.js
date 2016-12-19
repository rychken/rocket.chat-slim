Package.describe({
	name: 'rocketchat:crypto',
	version: '0.0.1',
	summary: 'RocketChat cryptography'
});

Npm.depends({
	'scryptsy': '2.0.0',
    'niceware': '1.0.3'
});

Package.onUse(function(api) {
	api.use('rocketchat:lib');
    api.use('jayuda:flx-jsencrypt@0.0.9');

	api.addFiles([
        'client/crypto.js',
        '.npm/package/node_modules/niceware/browser/niceware.js',
    ], 'client');
});
