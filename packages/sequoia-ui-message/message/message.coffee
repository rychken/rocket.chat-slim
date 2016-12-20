Template.message.helpers
	isBot: ->
		return 'bot' if this.bot?
	roleTags: ->
		unless Sequoia.settings.get('UI_DisplayRoles')
			return []
		roles = _.union(UserRoles.findOne(this.u?._id)?.roles, RoomRoles.findOne({'u._id': this.u?._id, rid: this.rid })?.roles)
		return Sequoia.models.Roles.find({ _id: { $in: roles }, description: { $exists: 1, $ne: '' } }, { fields: { description: 1 } })
	isGroupable: ->
		return 'false' if this.groupable is false
	isSequential: ->
		return 'sequential' if this.groupable isnt false
	avatarFromUsername: ->
		if this.avatar? and this.avatar[0] is '@'
			return this.avatar.replace(/^@/, '')
	getEmoji: (emoji) ->
		return renderEmoji emoji
	own: ->
		return 'own' if this.u?._id is Meteor.userId()
	timestamp: ->
		return +this.ts
	chatops: ->
		return 'chatops-message' if this.u?.username is Sequoia.settings.get('Chatops_Username')
	time: ->
		return moment(this.ts).format(Sequoia.settings.get('Message_TimeFormat'))
	date: ->
		return moment(this.ts).format(Sequoia.settings.get('Message_DateFormat'))
	isTemp: ->
		if @temp is true
			return 'temp'
	body: ->
		return Template.instance().body
	system: ->
		if Sequoia.MessageTypes.isSystemMessage(this)
			return 'system'
	edited: ->
		return Template.instance().wasEdited

	editTime: ->
		if Template.instance().wasEdited
			return moment(@editedAt).format(Sequoia.settings.get('Message_DateFormat') + ' ' + Sequoia.settings.get('Message_TimeFormat'))
	editedBy: ->
		return "" unless Template.instance().wasEdited
		# try to return the username of the editor,
		# otherwise a special "?" character that will be
		# rendered as a special avatar
		return @editedBy?.username or "?"
	canEdit: ->
		hasPermission = Sequoia.authz.hasAtLeastOnePermission('edit-message', this.rid)
		isEditAllowed = Sequoia.settings.get 'Message_AllowEditing'
		editOwn = this.u?._id is Meteor.userId()

		return unless hasPermission or (isEditAllowed and editOwn)

		blockEditInMinutes = Sequoia.settings.get 'Message_AllowEditing_BlockEditInMinutes'
		if blockEditInMinutes? and blockEditInMinutes isnt 0
			msgTs = moment(this.ts) if this.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			return currentTsDiff < blockEditInMinutes
		else
			return true

	canDelete: ->
		hasPermission = Sequoia.authz.hasAtLeastOnePermission('delete-message', this.rid )
		isDeleteAllowed = Sequoia.settings.get('Message_AllowDeleting')
		deleteOwn = this.u?._id is Meteor.userId()

		return unless hasPermission or (isDeleteAllowed and deleteOwn)

		blockDeleteInMinutes = Sequoia.settings.get 'Message_AllowDeleting_BlockDeleteInMinutes'
		if blockDeleteInMinutes? and blockDeleteInMinutes isnt 0
			msgTs = moment(this.ts) if this.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			return currentTsDiff < blockDeleteInMinutes
		else
			return true

	showEditedStatus: ->
		return Sequoia.settings.get 'Message_ShowEditedStatus'
	label: ->
		if @i18nLabel
			return t(@i18nLabel)
		else if @label
			return @label

	hasOembed: ->
		return false unless this.urls?.length > 0 and Template.oembedBaseWidget? and Sequoia.settings.get 'API_Embed'

		return false unless this.u?.username not in Sequoia.settings.get('API_EmbedDisabledFor')?.split(',')

		return true

	reactions: ->
		msgReactions = []
		userUsername = Meteor.user().username

		for emoji, reaction of @reactions
			total = reaction.usernames.length
			usernames = '@' + reaction.usernames.slice(0, 15).join(', @')

			usernames = usernames.replace('@'+userUsername, t('You').toLowerCase())

			if total > 15
				usernames = usernames + ' ' + t('And_more', { length: total - 15 }).toLowerCase()
			else
				usernames = usernames.replace(/,([^,]+)$/, ' '+t('and')+'$1')

			if usernames[0] isnt '@'
				usernames = usernames[0].toUpperCase() + usernames.substr(1)

			msgReactions.push
				emoji: emoji
				count: reaction.usernames.length
				usernames: usernames
				reaction: ' ' + t('Reacted_with').toLowerCase() + ' ' + emoji
				userReacted: reaction.usernames.indexOf(userUsername) > -1

		return msgReactions

	markUserReaction: (reaction) ->
		if reaction.userReacted
			return {
				class: 'selected'
			}

	hideReactions: ->
		return 'hidden' if _.isEmpty(@reactions)


	actionLinks: ->
		# remove 'method_id' and 'params' properties
		return _.map(@actionLinks, (actionLink, key) -> _.extend({ id: key }, _.omit(actionLink, 'method_id', 'params')))

	hideActionLinks: ->
		return 'hidden' if _.isEmpty(@actionLinks)

	injectIndex: (data, index) ->
		data.index = index
		return

	hideCog: ->
		subscription = Sequoia.models.Subscriptions.findOne({ rid: this.rid });
		return 'hidden' if not subscription?

	hideUsernames: ->
		prefs = Meteor.user()?.settings?.preferences
		return if prefs?.hideUsernames

Template.message.onCreated ->
	msg = Template.currentData()

	@wasEdited = msg.editedAt? and not Sequoia.MessageTypes.isSystemMessage(msg)

	@body = do ->
		isSystemMessage = Sequoia.MessageTypes.isSystemMessage(msg)
		messageType = Sequoia.MessageTypes.getType(msg)
		if messageType?.render?
			msg = messageType.render(msg)
		else if messageType?.template?
			# render template
		else if messageType?.message?
			if messageType.data?(msg)?
				msg = TAPi18n.__(messageType.message, messageType.data(msg))
			else
				msg = TAPi18n.__(messageType.message)
		else
			if msg.u?.username is Sequoia.settings.get('Chatops_Username')
				msg.html = msg.msg
				msg = Sequoia.callbacks.run 'renderMentions', msg
				# console.log JSON.stringify message
				msg = msg.html
			else
				msg = renderMessageBody msg

		if isSystemMessage
			return Sequoia.Markdown msg
		else
			return msg

Template.message.onViewRendered = (context) ->
	view = this
	this._domrange.onAttached (domRange) ->
		currentNode = domRange.lastNode()
		currentDataset = currentNode.dataset
		previousNode = currentNode.previousElementSibling
		nextNode = currentNode.nextElementSibling
		$currentNode = $(currentNode)
		$nextNode = $(nextNode)

		unless previousNode?
			$currentNode.addClass('new-day').removeClass('sequential')

		else if previousNode?.dataset?
			previousDataset = previousNode.dataset

			if previousDataset.date isnt currentDataset.date
				$currentNode.addClass('new-day').removeClass('sequential')
			else
				$currentNode.removeClass('new-day')

			if previousDataset.groupable is 'false' or currentDataset.groupable is 'false'
				$currentNode.removeClass('sequential')
			else
				if previousDataset.username isnt currentDataset.username or parseInt(currentDataset.timestamp) - parseInt(previousDataset.timestamp) > Sequoia.settings.get('Message_GroupingPeriod') * 1000
					$currentNode.removeClass('sequential')
				else if not $currentNode.hasClass 'new-day'
					$currentNode.addClass('sequential')

		if nextNode?.dataset?
			nextDataset = nextNode.dataset

			if nextDataset.date isnt currentDataset.date
				$nextNode.addClass('new-day').removeClass('sequential')
			else
				$nextNode.removeClass('new-day')

			if nextDataset.groupable isnt 'false'
				if nextDataset.username isnt currentDataset.username or parseInt(nextDataset.timestamp) - parseInt(currentDataset.timestamp) > Sequoia.settings.get('Message_GroupingPeriod') * 1000
					$nextNode.removeClass('sequential')
				else if not $nextNode.hasClass 'new-day'
					$nextNode.addClass('sequential')

		if not nextNode?
			templateInstance = if $('#chat-window-' + context.rid)[0] then Blaze.getView($('#chat-window-' + context.rid)[0])?.templateInstance() else null

			if currentNode.classList.contains('own') is true
				templateInstance?.atBottom = true
			else
				if templateInstance?.firstNode && templateInstance?.atBottom is false
					newMessage = templateInstance?.find(".new-message")
					newMessage?.className = "new-message"
