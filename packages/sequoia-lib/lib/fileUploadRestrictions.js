Sequoia.fileUploadMediaWhiteList = function() {
	var mediaTypeWhiteList = Sequoia.settings.get('FileUpload_MediaTypeWhiteList');

	if (!mediaTypeWhiteList || mediaTypeWhiteList === '*') {
		return;
	}
	return _.map(mediaTypeWhiteList.split(','), function(item) {
		return item.trim();
	});
};

Sequoia.fileUploadIsValidContentType = function(type) {
	var list, wildCardGlob, wildcards;
	list = Sequoia.fileUploadMediaWhiteList();
	if (!list || _.contains(list, type)) {
		return true;
	} else {
		wildCardGlob = '/*';
		wildcards = _.filter(list, function(item) {
			return item.indexOf(wildCardGlob) > 0;
		});
		if (_.contains(wildcards, type.replace(/(\/.*)$/, wildCardGlob))) {
			return true;
		}
	}
	return false;
};
