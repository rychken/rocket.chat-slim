Template.home.helpers
	title: ->
		return Sequoia.settings.get 'Layout_Home_Title'
	body: ->
		return Sequoia.settings.get 'Layout_Home_Body'
