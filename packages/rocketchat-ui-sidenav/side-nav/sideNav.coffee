Template.sideNav.helpers
	flexTemplate: ->
		return SideNav.getFlex().template

	flexData: ->
		return SideNav.getFlex().data

	footer: ->
		return Sequoia.settings.get 'Layout_Sidenav_Footer'

	showStarredRooms: ->
		favoritesEnabled = Sequoia.settings.get 'Favorite_Rooms'
		hasFavoriteRoomOpened = ChatSubscription.findOne({ f: true, open: true })

		return true if favoritesEnabled and hasFavoriteRoomOpened

	roomType: ->
		return Sequoia.roomTypes.getTypes()

	canShowRoomType: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = Sequoia.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return Sequoia.roomTypes.checkCondition(@) and @template isnt 'privateGroups'
		else
			return Sequoia.roomTypes.checkCondition(@)

	templateName: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = Sequoia.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return if @template is 'channels' then 'combined' else @template
		else
			return @template

Template.sideNav.events
	'click .close-flex': ->
		SideNav.closeFlex()

	'click .arrow': ->
		SideNav.toggleCurrent()

	'mouseenter .header': ->
		SideNav.overArrow()

	'mouseleave .header': ->
		SideNav.leaveArrow()

	'scroll .rooms-list': ->
		menu.updateUnreadBars()

	'dropped .side-nav': (e) ->
		e.preventDefault()

Template.sideNav.onRendered ->
	SideNav.init()
	menu.init()

	Meteor.defer ->
		menu.updateUnreadBars()
