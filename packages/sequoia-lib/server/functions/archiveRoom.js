Sequoia.archiveRoom = function(rid) {
	Sequoia.models.Rooms.archiveById(rid);
	Sequoia.models.Subscriptions.archiveByRoomId(rid);
};
