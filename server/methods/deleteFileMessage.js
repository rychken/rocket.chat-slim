Meteor.methods({
	deleteFileMessage: function(fileID) {
		check(fileID, String);

		return Meteor.call('deleteMessage', Sequoia.models.Messages.getMessageByFileId(fileID));
	}
});
