Sequoia.settings.get 'Log_Package', (key, value) ->
	LoggerManager?.showPackage = value

Sequoia.settings.get 'Log_File', (key, value) ->
	LoggerManager?.showFileAndLine = value

Sequoia.settings.get 'Log_Level', (key, value) ->
	if value?
		LoggerManager?.logLevel = parseInt value
		Meteor.setTimeout ->
			LoggerManager?.enable(true)
		, 200
