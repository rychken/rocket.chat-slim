Meteor.startup(function() {
	Sequoia.MessageTypes.registerType({
		id: 'jitsi_call_started',
		system: true,
		message: 'Started a Video Call!'
	});
});
