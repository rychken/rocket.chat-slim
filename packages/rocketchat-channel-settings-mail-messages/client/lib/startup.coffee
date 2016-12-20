Meteor.startup ->
	Sequoia.ChannelSettings.addOption
		id: 'mail-messages'
		template: 'channelSettingsMailMessages'
		validation: ->
			return Sequoia.authz.hasAllPermission('mail-messages')

	Sequoia.callbacks.add 'roomExit', (mainNode) ->
		messagesBox = $('.messages-box')
		if messagesBox.get(0)?
			instance = Blaze.getView(messagesBox.get(0))?.templateInstance()
			instance?.resetSelection(false)
	, Sequoia.callbacks.priority.MEDIUM, 'room-exit-mail-messages'
