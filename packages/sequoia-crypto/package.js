Package.describe({
	name: 'sequoia:crypto',
	version: '0.0.1',
	summary: 'Sequoia cryptography'
});

Npm.depends({
	'scryptsy': '2.0.0',
    'niceware': '1.0.3'
});

Package.onUse(function(api) {
	api.use('sequoia:lib');
    api.use('jayuda:flx-jsencrypt@0.0.9');

	api.addFiles([
        'client/crypto.js',
        '.npm/package/node_modules/niceware/browser/niceware.js',
    ], 'client');
});
