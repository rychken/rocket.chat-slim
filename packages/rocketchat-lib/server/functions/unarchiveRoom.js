Sequoia.unarchiveRoom = function(rid) {
	Sequoia.models.Rooms.unarchiveById(rid);
	Sequoia.models.Subscriptions.unarchiveByRoomId(rid);
};
