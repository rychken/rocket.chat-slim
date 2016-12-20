Meteor.startup ->
	Sequoia.settings.onload 'Force_SSL', (key, value) ->
		Meteor.absoluteUrl.defaultOptions.secure = value
