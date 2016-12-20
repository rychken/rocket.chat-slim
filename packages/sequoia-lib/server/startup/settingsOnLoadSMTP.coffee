buildMailURL = _.debounce ->
	console.log 'Updating process.env.MAIL_URL'
	if Sequoia.settings.get('SMTP_Host')
		process.env.MAIL_URL = "smtp://"
		if Sequoia.settings.get('SMTP_Username') and Sequoia.settings.get('SMTP_Password')
			process.env.MAIL_URL += encodeURIComponent(Sequoia.settings.get('SMTP_Username')) + ':' + encodeURIComponent(Sequoia.settings.get('SMTP_Password')) + '@'
		process.env.MAIL_URL += encodeURIComponent(Sequoia.settings.get('SMTP_Host'))
		if Sequoia.settings.get('SMTP_Port')
			process.env.MAIL_URL += ':' + parseInt(Sequoia.settings.get('SMTP_Port'))
, 500

Sequoia.settings.onload 'SMTP_Host', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

Sequoia.settings.onload 'SMTP_Port', (key, value, initialLoad) ->
	buildMailURL()

Sequoia.settings.onload 'SMTP_Username', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

Sequoia.settings.onload 'SMTP_Password', (key, value, initialLoad) ->
	if _.isString value
		buildMailURL()

Meteor.startup ->
	buildMailURL()
