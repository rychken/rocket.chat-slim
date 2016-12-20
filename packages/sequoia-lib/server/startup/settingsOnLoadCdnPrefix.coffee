Sequoia.settings.onload 'CDN_PREFIX', (key, value, initialLoad) ->
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value

Meteor.startup ->
	value = Sequoia.settings.get 'CDN_PREFIX'
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value
