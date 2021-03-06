Template.accountFlex.events
	'mouseenter header': ->
		SideNav.overArrow()

	'mouseleave header': ->
		SideNav.leaveArrow()

	'click header': ->
		SideNav.closeFlex()

	'click .cancel-settings': ->
		SideNav.closeFlex()

	'click .account-link': ->
		menu.close()

Template.accountFlex.helpers
	allowUserProfileChange: ->
		return Sequoia.settings.get("Accounts_AllowUserProfileChange")
	allowUserAvatarChange: ->
		return Sequoia.settings.get("Accounts_AllowUserAvatarChange")