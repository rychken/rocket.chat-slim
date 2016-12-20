Template.roomSearch.helpers
	roomIcon: ->
		return 'icon-at' if this.type is 'u'

		if this.type is 'r'
			return Sequoia.roomTypes.getIcon this.t

	userStatus: ->
		if this.type is 'u'
			return 'status-' + this.status
