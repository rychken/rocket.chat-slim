
Meteor.methods({
	'jitsi:updateTimeout': (rid) => {

		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'jitsi:updateTimeout' });
		}

		let room = Sequoia.models.Rooms.findOneById(rid);
		let currentTime = new Date().getTime();

		let jitsiTimeout = new Date((room && room.jitsiTimeout) || currentTime).getTime();

		if (jitsiTimeout <= currentTime) {
			Sequoia.models.Rooms.setJitsiTimeout(rid, new Date(currentTime + 35*1000));
			Sequoia.models.Messages.createWithTypeRoomIdMessageAndUser('jitsi_call_started', rid, '', Meteor.user(), {
				actionLinks : [
					{ icon: 'icon-videocam', label: 'Click To Join!', method_id: 'joinJitsiCall', params: ''}
				]
			});
		} else if ((jitsiTimeout - currentTime) / 1000 <= 15) {
			Sequoia.models.Rooms.setJitsiTimeout(rid, new Date(jitsiTimeout + 25*1000));
		}
	}
});
