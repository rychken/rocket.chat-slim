const commands = {
	go(data) {
		if (typeof data.path !== 'string' || data.path.trim().length === 0) {
			return console.error('`path` not defined');
		}
		FlowRouter.go(data.path, null, FlowRouter.current().queryParams);
	},


	'set-user-status'(data) {
		AccountBox.setStatus(data.status);
	},

	'login-with-token'(data) {
		if (typeof data.token === 'string') {
			Meteor.loginWithToken(data.token, function() {
				console.log('Iframe command [login-with-token]: result', arguments);
			});
		}
	},

	'logout'() {
		const user = Meteor.user();
		Meteor.logout(() => {
			Sequoia.callbacks.run('afterLogoutCleanUp', user);
			Meteor.call('logoutCleanUp', user);
			return FlowRouter.go('home');
		});
	}
};

window.addEventListener('message', (e) => {
	if (Sequoia.settings.get('Iframe_Integration_receive_enable') !== true) {
		return;
	}

	if (typeof e.data !== 'object' || typeof e.data.externalCommand !== 'string') {
		return;
	}

	let origins = Sequoia.settings.get('Iframe_Integration_receive_origin');

	if (origins !== '*' && origins.split(',').indexOf(e.origin) === -1) {
		return console.error('Origin not allowed', e.origin);
	}

	const command = commands[e.data.externalCommand];
	if (command) {
		command(e.data, e);
	}
});
