Meteor.methods({
	setEmail: function(email) {

		check (email, String);

		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'setEmail' });
		}

		const user = Meteor.user();

		if (!Sequoia.settings.get('Accounts_AllowEmailChange')) {
			throw new Meteor.Error('error-action-not-allowed', 'Changing email is not allowed', { method: 'setEmail', action: 'Changing_email' });
		}

		if (user.emails && user.emails[0] && user.emails[0].address === email) {
			return email;
		}

		if (!Sequoia.setEmail(user._id, email)) {
			throw new Meteor.Error('error-could-not-change-email', 'Could not change email', { method: 'setEmail' });
		}

		return email;
	}
});

Sequoia.RateLimiter.limitMethod('setEmail', 1, 1000, {
	userId: function(/*userId*/) { return true; }
});
