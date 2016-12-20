Template.loginHeader.helpers
	logoUrl: ->
		asset = Sequoia.settings.get('Assets_logo')
		if asset?
			return asset.url or asset.defaultUrl
