Package.describe({
	name: 'sequoia:ui',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use([
		'accounts-base',
		'mongo',
		'session',
		'jquery',
		'tracker',
		'reactive-var',
		'ecmascript',
		'templating',
		'coffeescript',
		'underscore',
		'sequoia:lib',
		'raix:push',
		'raix:ui-dropped-event'
	]);

	api.use('kadira:flow-router', 'client');

	// LIB FILES
	api.addFiles([
		'lib/getAvatarUrlFromUsername.coffee',
		'lib/accountBox.coffee',
		'lib/accounts.coffee',
		'lib/avatar.coffee',
		'lib/chatMessages.coffee',
		'lib/collections.coffee',
		'lib/customEventPolyfill.js',
		'lib/fileUpload.coffee',
		'lib/fireEvent.js',
		'lib/iframeCommands.js',
		'lib/jquery.swipebox.min.js',
		'lib/log.coffee',
		'lib/menu.coffee',
		'lib/modal.coffee',
		'lib/Modernizr.js',
		'lib/msgTyping.coffee',
		'lib/notification.coffee',
		'lib/parentTemplate.js',
		'lib/readMessages.coffee',
		'lib/rocket.coffee',
		'lib/RoomHistoryManager.coffee',
		'lib/RoomManager.coffee',
		'lib/sideNav.coffee',
		'lib/tapi18n.coffee',
		'lib/textarea-autogrow.js',
	], 'client');

	// LIB CORDOVA
	api.addFiles('lib/cordova/keyboard-fix.coffee', 'client');
	api.addFiles('lib/cordova/push.coffee', 'client');
	api.addFiles('lib/cordova/urls.coffee', 'client');
	api.addFiles('lib/cordova/user-state.js', 'client');

	// LIB RECORDERJS
	api.addFiles('lib/recorderjs/audioRecorder.coffee', 'client');
	api.addFiles('lib/recorderjs/videoRecorder.coffee', 'client');
	api.addFiles('lib/recorderjs/recorder.js', 'client');

	// TEXTAREA CURSOR MANAGEMENT
	api.addFiles('lib/textarea-cursor/set-cursor-position.js', 'client');

	// TEMPLATE FILES
	api.addFiles('views/cmsPage.html', 'client');
	api.addFiles('views/fxos.html', 'client');
	api.addFiles('views/modal.html', 'client');
	api.addFiles('views/404/roomNotFound.html', 'client');
	api.addFiles('views/404/invalidSecretURL.html', 'client');
	api.addFiles('views/app/audioNotification.html', 'client');
	api.addFiles('views/app/burger.html', 'client');
	api.addFiles('views/app/home.html', 'client');
	api.addFiles('views/app/notAuthorized.html', 'client');
	api.addFiles('views/app/pageContainer.html', 'client');
	api.addFiles('views/app/pageSettingsContainer.html', 'client');
	api.addFiles('views/app/privateHistory.html', 'client');
	api.addFiles('views/app/room.html', 'client');
	api.addFiles('views/app/roomSearch.html', 'client');
	api.addFiles('views/app/secretURL.html', 'client');
	api.addFiles('views/app/userSearch.html', 'client');
	api.addFiles('views/app/spotlight/spotlight.html', 'client');
	api.addFiles('views/app/spotlight/spotlightTemplate.html', 'client');
	api.addFiles('views/app/videoCall/videoButtons.html', 'client');
	api.addFiles('views/app/videoCall/videoCall.html', 'client');

	api.addFiles('views/cmsPage.coffee', 'client');
	api.addFiles('views/fxos.coffee', 'client');
	api.addFiles('views/modal.coffee', 'client');
	api.addFiles('views/404/roomNotFound.coffee', 'client');
	api.addFiles('views/app/burger.coffee', 'client');
	api.addFiles('views/app/home.coffee', 'client');
	api.addFiles('views/app/privateHistory.coffee', 'client');
	api.addFiles('views/app/room.coffee', 'client');
	api.addFiles('views/app/roomSearch.coffee', 'client');
	api.addFiles('views/app/secretURL.coffee', 'client');
	api.addFiles('views/app/spotlight/mobileMessageMenu.coffee', 'client');
	api.addFiles('views/app/spotlight/spotlight.coffee', 'client');
	api.addFiles('views/app/spotlight/spotlightTemplate.js', 'client');
	api.addFiles('views/app/videoCall/videoButtons.coffee', 'client');
	api.addFiles('views/app/videoCall/videoCall.coffee', 'client');
});
