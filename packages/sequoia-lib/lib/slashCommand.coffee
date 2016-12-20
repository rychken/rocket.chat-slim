Sequoia.slashCommands =
	commands: {}

Sequoia.slashCommands.add = (command, callback, options) ->
	Sequoia.slashCommands.commands[command] =
		command: command
		callback: callback
		params: options?.params
		description: options?.description
		clientOnly: options?.clientOnly or false

	return

Sequoia.slashCommands.run = (command, params, item) ->
	if Sequoia.slashCommands.commands[command]?.callback?
		callback = Sequoia.slashCommands.commands[command].callback
		callback command, params, item


Meteor.methods
	slashCommand: (command) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'slashCommand' }

		Sequoia.slashCommands.run command.cmd, command.params, command.msg

