Package.describe({
	name: 'sequoia:lib',
	version: '0.0.1',
	summary: 'Sequoia libraries',
	git: ''
});

Npm.depends({
	'bad-words': '1.3.1',
	'node-dogstatsd': '0.0.6',
	'localforage': '1.4.2',
	'bugsnag': '1.8.0'
});

Package.onUse(function(api) {
	api.use('rate-limit');
	api.use('session');
	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('accounts-base');
	api.use('coffeescript');
	api.use('ecmascript');
	api.use('random');
	api.use('check');
	api.use('tracker');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('mongo');
	api.use('underscorestring:underscore.string');
	api.use('matb33:collection-hooks');
	api.use('service-configuration');
	api.use('check');
	api.use('momentjs:moment');
	api.use('sequoia:i18n');
	api.use('rocketchat:streamer');
	api.use('sequoia:version');
	api.use('sequoia:logger');

	api.use('templating', 'client');
	api.use('kadira:flow-router');
	api.use('kadira:blaze-layout');

	api.addFiles('lib/core.coffee');

	// DEBUGGER
	api.addFiles('server/lib/debug.js', 'server');

	// COMMON LIB
	api.addFiles([
		'lib/settings.coffee',
		'lib/configLogger.coffee',
		'lib/callbacks.coffee',
		'lib/fileUploadRestrictions.js',
		'lib/placeholders.js',
		'lib/promises.coffee',
		'lib/roomTypesCommon.coffee',
		'lib/slashCommand.coffee',
		'lib/Message.coffee',
		'lib/MessageTypes.coffee',
		'lib/RegExp.coffee',
		'lib/francocatena_fix.coffee',
		'lib/underscore.string.coffee',
	]);

	// SERVER LIB
	api.addFiles('server/lib/bugsnag.js', 'server');
	api.addFiles('server/lib/RateLimiter.coffee', 'server');
	api.addFiles('server/lib/defaultBlockedDomainsList.js', 'server');
	api.addFiles('server/lib/notifyUsersOnMessage.js', 'server');
	api.addFiles('server/lib/roomTypes.coffee', 'server');
	api.addFiles('server/lib/sendEmailOnMessage.js', 'server');
	api.addFiles('server/lib/sendNotificationsOnMessage.js', 'server');
	api.addFiles('server/lib/validateEmailDomain.js', 'server');

	// SERVER FUNCTIONS
	api.addFiles('server/functions/addUserToDefaultChannels.js', 'server');
	api.addFiles('server/functions/addUserToRoom.js', 'server');
	api.addFiles('server/functions/archiveRoom.js', 'server');
	api.addFiles('server/functions/checkUsernameAvailability.coffee', 'server');
	api.addFiles('server/functions/checkEmailAvailability.js', 'server');
	api.addFiles('server/functions/createRoom.js', 'server');
	api.addFiles('server/functions/deleteMessage.js', 'server');
	api.addFiles('server/functions/deleteUser.js', 'server');
	api.addFiles('server/functions/removeUserFromRoom.js', 'server');
	api.addFiles('server/functions/saveUser.js', 'server');
	api.addFiles('server/functions/saveCustomFields.js', 'server');
	api.addFiles('server/functions/sendMessage.coffee', 'server');
	api.addFiles('server/functions/settings.coffee', 'server');
	api.addFiles('server/functions/setUserAvatar.js', 'server');
	api.addFiles('server/functions/setUsername.coffee', 'server');
	api.addFiles('server/functions/setEmail.js', 'server');
	api.addFiles('server/functions/unarchiveRoom.js', 'server');
	api.addFiles('server/functions/updateMessage.js', 'server');
	api.addFiles('server/functions/Notifications.coffee', 'server');

	// SERVER MODELS
	api.addFiles('server/models/_Base.js', 'server');
	api.addFiles('server/models/Messages.coffee', 'server');
	api.addFiles('server/models/Reports.coffee', 'server');
	api.addFiles('server/models/Rooms.coffee', 'server');
	api.addFiles('server/models/Settings.coffee', 'server');
	api.addFiles('server/models/Subscriptions.coffee', 'server');
	api.addFiles('server/models/Uploads.coffee', 'server');
	api.addFiles('server/models/Users.coffee', 'server');

	api.addFiles('server/startup/statsTracker.js', 'server');

	// SERVER PUBLICATIONS
	api.addFiles('server/publications/settings.coffee', 'server');

	// SERVER METHODS
	api.addFiles([
		'server/methods/addAllUserToRoom.js',
		'server/methods/addRoomModerator.coffee',
		'server/methods/addRoomOwner.coffee',
		'server/methods/addUserToRoom.coffee',
		'server/methods/archiveRoom.coffee',
		'server/methods/canAccessRoom.coffee',
		'server/methods/channelsList.coffee',
		'server/methods/checkRegistrationSecretURL.coffee',
		'server/methods/createChannel.coffee',
		'server/methods/createDirectMessage.coffee',
		'server/methods/createPrivateGroup.coffee',
		'server/methods/deleteFileMessage.js',
		'server/methods/deleteMessage.coffee',
		'server/methods/deleteUser.coffee',
		'server/methods/deleteUserOwnAccount.js',
		'server/methods/eraseRoom.coffee',
		'server/methods/filterATAllTag.js',
		'server/methods/filterBadWords.js',
		'server/methods/getAvatarSuggestion.coffee',
		'server/methods/getRoomIdByNameOrId.coffee',
		'server/methods/getRoomRoles.js',
		'server/methods/getTotalChannels.coffee',
		'server/methods/getUserRoles.js',
		'server/methods/getUsernameSuggestion.coffee',
		'server/methods/getUsersOfRoom.js',
		'server/methods/groupsList.js',
		'server/methods/hideRoom.coffee',
		'server/methods/insertOrUpdateUser.coffee',
		'server/methods/joinDefaultChannels.coffee',
		'server/methods/joinRoom.coffee',
		'server/methods/leaveRoom.coffee',
		'server/methods/loadHistory.coffee',
		'server/methods/loadLocale.coffee',
		'server/methods/loadMissedMessages.coffee',
		'server/methods/loadNextMessages.coffee',
		'server/methods/loadSurroundingMessages.coffee',
		'server/methods/logoutCleanUp.coffee',
		'server/methods/messageSearch.js',
		'server/methods/migrate.coffee',
		'server/methods/muteUserInRoom.coffee',
		'server/methods/openRoom.coffee',
		'server/methods/readMessages.coffee',
		'server/methods/registerUser.coffee',
		'server/methods/removeRoomModerator.coffee',
		'server/methods/removeRoomOwner.coffee',
		'server/methods/removeUserFromRoom.coffee',
		'server/methods/reportMessage.coffee',
		'server/methods/resetAvatar.coffee',
		'server/methods/restartServer.coffee',
		'server/methods/robotMethods.coffee',
		'server/methods/saveSetting.js',
		'server/methods/saveUserPreferences.coffee',
		'server/methods/saveUserProfile.coffee',
		'server/methods/sendConfirmationEmail.coffee',
		'server/methods/sendForgotPasswordEmail.coffee',
		'server/methods/sendInvitationEmail.coffee',
		'server/methods/sendMessage.coffee',
		'server/methods/sendSMTPTestEmail.coffee',
		'server/methods/setAdminStatus.coffee',
		'server/methods/setAvatarFromService.coffee',
		'server/methods/setEmail.js',
		'server/methods/setRealName.coffee',
		'server/methods/setUserActiveStatus.coffee',
		'server/methods/setUserPassword.coffee',
		'server/methods/setUsername.coffee',
		'server/methods/toogleFavorite.coffee',
		'server/methods/unarchiveRoom.coffee',
		'server/methods/unmuteUserInRoom.coffee',
		'server/methods/updateMessage.coffee',
		'server/methods/userSetUtcOffset.coffee',
	], 'server');


	// COMMON STARTUP
	api.addFiles('lib/startup/settingsOnLoadSiteUrl.coffee');

	// SERVER STARTUP
	api.addFiles('server/startup/settingsOnLoadCdnPrefix.coffee', 'server');
	api.addFiles('server/startup/settingsOnLoadSMTP.coffee', 'server');
	api.addFiles('server/startup/settings.coffee', 'server');

	// SERVER PUBLICATIONS
	api.addFiles([
		'server/publications/activeUsers.coffee',
		'server/publications/channelAndPrivateAutocomplete.coffee',
		'server/publications/fullUserData.coffee',
		'server/publications/messages.coffee',
		'server/publications/privateHistory.coffee',
		'server/publications/room.coffee',
		'server/publications/roomFiles.coffee',
		'server/publications/roomSubscriptionsByRole.coffee',
		'server/publications/spotlight.coffee',
		'server/publications/subscription.coffee',
		'server/publications/userAutocomplete.coffee',
		'server/publications/userChannels.coffee',
		'server/publications/userData.coffee',
	], 'server');

	// CLIENT STARTUP
	api.addFiles([
		'client/startup/emailVerification.js',
		'client/startup/roomObserve.coffee',
		'client/startup/startup.coffee',
		'client/startup/unread.coffee',
		'client/startup/userSetUtcOffset.js',
		'client/startup/usersObserve.coffee',
		'client/startup/notification.coffee',
		'client/startup/updateAvatar.coffee',
		], 'client');

	// CLIENT LIB
	api.addFiles([
		'client/lib/handleError.js',
		'client/lib/cachedCollection.js',
		'client/lib/openRoom.coffee',
		'client/lib/roomExit.coffee',
		'client/lib/settings.coffee',
		'client/lib/roomTypes.coffee',
		'client/lib/userRoles.js',
		'client/lib/Layout.js',
		'client/Notifications.coffee',
		], 'client');

	// CLIENT ROUTES
	api.addFiles([
		'client/routes/adminRouter.coffee',
		'client/routes/router.coffee',
		'client/routes/roomRoute.js',
		], 'client');

	// CLIENT METHODS
	api.addFiles('client/methods/deleteMessage.coffee', 'client');
	api.addFiles('client/methods/hideRoom.coffee', 'client');
	api.addFiles('client/methods/leaveRoom.coffee', 'client');
	api.addFiles('client/methods/openRoom.coffee', 'client');
	api.addFiles('client/methods/sendMessage.coffee', 'client');
	api.addFiles('client/methods/setUserActiveStatus.coffee', 'client');
	api.addFiles('client/methods/toggleFavorite.coffee', 'client');
	api.addFiles('client/methods/updateMessage.coffee', 'client');

	// CLIENT NO DIRECTORY
	api.addFiles('client/AdminBox.coffee', 'client');
	api.addFiles('client/TabBar.coffee', 'client');
	api.addFiles('client/MessageAction.coffee', 'client');
	api.addFiles('client/defaultTabBars.js', 'client');
	api.addFiles('client/CustomTranslations.js', 'client');

	// CLIENT MODELS
	api.addFiles('client/models/_Base.coffee', 'client');
	api.addFiles('client/models/Uploads.coffee', 'client');

	api.addFiles('startup/defaultRoomTypes.coffee');

	// VERSION
	api.addFiles('sequoia.info');

	// EXPORT
	api.export('Sequoia');

	api.imply('tap:i18n');
});

Package.onTest(function(api) {
	api.use('coffeescript');
	api.use('sanjo:jasmine@0.20.2');
	api.use('sequoia:lib');
	api.addFiles('tests/jasmine/server/unit/models/_Base.spec.coffee', 'server');
});
