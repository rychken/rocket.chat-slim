Meteor.startup(function() {
	Tracker.autorun(function() {
		if (Sequoia.settings.get('Jitsi_Enabled')) {
			Sequoia.TabBar.addButton({
				groups: ['directmessage', 'privategroup'],
				id: 'video',
				i18nTitle: 'Video Chat',
				icon: 'icon-videocam',
				iconColor: 'red',
				template: 'videoFlexTab',
				width: 790,
				order: 12
			});
		} else {
			Sequoia.TabBar.removeButton('video');
		}
	});

	Tracker.autorun(function() {
		if (Sequoia.settings.get('Jitsi_Enabled') && Sequoia.settings.get('Jitsi_Enable_Channels')) {
			Sequoia.TabBar.addGroup('video', ['channel']);
		} else {
			Sequoia.TabBar.removeGroup('video', ['channel']);
		}
	});

	Tracker.autorun(function() {
		if (Sequoia.settings.get('Jitsi_Enabled')) {
			// Load from the jitsi meet instance.
			if (typeof JitsiMeetExternalAPI === 'undefined') {
				$.getScript('/packages/sequoia_videobridge/client/public/external_api.js');
			}

			// Compare current time to call started timeout.  If its past then call is probably over.
			if (Session.get('openedRoom')) {
				let rid = Session.get('openedRoom');

				let room = Sequoia.models.Rooms.findOne({_id: rid});
				let currentTime = new Date().getTime();
				let jitsiTimeout = new Date((room && room.jitsiTimeout) || currentTime).getTime();

				if (jitsiTimeout > currentTime) {
					Sequoia.TabBar.updateButton('video', { class: 'attention' });
				} else {
					Sequoia.TabBar.updateButton('video', { class: '' });
				}
			}
		}
	});
});
