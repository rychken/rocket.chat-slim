/* globals FileUpload */
Sequoia.deleteMessage = function(message, user) {
	let keepHistory = Sequoia.settings.get('Message_KeepHistory');
	let showDeletedStatus = Sequoia.settings.get('Message_ShowDeletedStatus');

	if (keepHistory) {
		if (showDeletedStatus) {
			Sequoia.models.Messages.cloneAndSaveAsHistoryById(message._id);
		} else {
			Sequoia.models.Messages.setHiddenById(message._id, true);
		}

		if (message.file && message.file._id) {
			Sequoia.models.Uploads.update(message.file._id, { $set: { _hidden: true } });
		}
	} else {
		if (!showDeletedStatus) {
			Sequoia.models.Messages.removeById(message._id);
		}

		if (message.file && message.file._id) {
			FileUpload.delete(message.file._id);
		}
	}

	if (showDeletedStatus) {
		Sequoia.models.Messages.setAsDeletedByIdAndUser(message._id, user);
	} else {
		Sequoia.Notifications.notifyRoom(message.rid, 'deleteMessage', { _id: message._id });
	}
};
