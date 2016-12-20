Sequoia.setUserAvatar = function(user, dataURI, contentType, service) {
	if (service === 'initials') {
		return Sequoia.models.Users.setAvatarOrigin(user._id, service);
	}

	if (service === 'url') {
		let result = null;

		try {
			result = HTTP.get(dataURI, { npmRequestOptions: {encoding: 'binary'} });
		} catch (error) {
			console.log(`Error while handling the setting of the avatar from a url (${dataURI}) for ${user.username}:`, error);
			throw new Meteor.Error('error-avatar-url-handling', `Error while handling avatar setting from a URL (${dataURI}) for ${user.username}`, { function: 'Sequoia.setUserAvatar', url: dataURI, username: user.username });
		}

		if (result.statusCode !== 200) {
			console.log(`Not a valid response, ${result.statusCode}, from the avatar url: ${dataURI}`);
			throw new Meteor.Error('error-avatar-invalid-url', `Invalid avatar URL: ${dataURI}`, { function: 'Sequoia.setUserAvatar', url: dataURI });
		}

		if (!/image\/.+/.test(result.headers['content-type'])) {
			console.log(`Not a valid content-type from the provided url, ${result.headers['content-type']}, from the avatar url: ${dataURI}`);
			throw new Meteor.Error('error-avatar-invalid-url', `Invalid avatar URL: ${dataURI}`, { function: 'Sequoia.setUserAvatar', url: dataURI });
		}

		let ars = SequoiaFile.bufferToStream(new Buffer(result.content, 'binary'));
		SequoiaFileAvatarInstance.deleteFile(encodeURIComponent(`${user.username}.jpg`));
		let aws = SequoiaFileAvatarInstance.createWriteStream(encodeURIComponent(`${user.username}.jpg`), result.headers['content-type']);
		aws.on('end', Meteor.bindEnvironment(function() {
			Meteor.setTimeout(function() {
				console.log(`Set ${user.username}'s avatar from the url: ${dataURI}`);
				Sequoia.models.Users.setAvatarOrigin(user._id, service);
				Sequoia.Notifications.notifyAll('updateAvatar', { username: user.username });
			}, 500);
		}));

		ars.pipe(aws);
		return;
	}

	let fileData = SequoiaFile.dataURIParse(dataURI);
	let image = fileData.image;
	contentType = fileData.contentType;

	let rs = SequoiaFile.bufferToStream(new Buffer(image, 'base64'));
	SequoiaFileAvatarInstance.deleteFile(encodeURIComponent(`${user.username}.jpg`));
	let ws = SequoiaFileAvatarInstance.createWriteStream(encodeURIComponent(`${user.username}.jpg`), contentType);
	ws.on('end', Meteor.bindEnvironment(function() {
		Meteor.setTimeout(function() {
			Sequoia.models.Users.setAvatarOrigin(user._id, service);
			Sequoia.Notifications.notifyAll('updateAvatar', {username: user.username});
		}, 500);
	}));
	rs.pipe(ws);
};
