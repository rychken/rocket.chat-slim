import bugsnag from 'bugsnag';

Sequoia.bugsnag = bugsnag;

Sequoia.settings.get('Bugsnag_api_key', (key, value) => {
	if (value) {
		bugsnag.register(value);
	}
});

const notify = function(message, stack) {
	if (typeof stack === 'string') {
		message += ' ' + stack;
	}
	const options = { app: { version: Sequoia.Info.version, info: Sequoia.Info } };
	const error = new Error(message);
	error.stack = stack;
	Sequoia.bugsnag.notify(error, options);
};

process.on('uncaughtException', Meteor.bindEnvironment((error) => {
	notify(error.message, error.stack);
}));

let originalMeteorDebug = Meteor._debug;
Meteor._debug = function() {
	notify(...arguments);
	return originalMeteorDebug(...arguments);
};
