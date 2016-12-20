Template.account.helpers
	flexOpened: ->
		return 'opened' if Sequoia.TabBar.isFlexOpen()
	arrowPosition: ->
		console.log 'room.helpers arrowPosition' if window.rocketDebug
		return 'left' unless Sequoia.TabBar.isFlexOpen()

Template.account.onRendered ->
	Tracker.afterFlush ->
		SideNav.setFlex "accountFlex"
		SideNav.openFlex()
