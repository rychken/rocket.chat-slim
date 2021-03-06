/* globals Slingshot */

import filesize from 'filesize';

Slingshot.fileRestrictions('sequoia-uploads', {
	authorize: function(file/*, metaContext*/) {
		if (!Sequoia.fileUploadIsValidContentType(file.type)) {
			throw new Meteor.Error(TAPi18n.__('error-invalid-file-type'));
		}

		var maxFileSize = Sequoia.settings.get('FileUpload_MaxFileSize');

		if (maxFileSize && maxFileSize < file.size) {
			throw new Meteor.Error(TAPi18n.__('File_exceeds_allowed_size_of_bytes', { size: filesize(maxFileSize) }));
		}

		//Deny uploads if user is not logged in.
		if (!this.userId) {
			throw new Meteor.Error('login-require', 'Please login before posting files');
		}

		return true;
	},
	maxSize: 0,
	allowedFileTypes: null
});
