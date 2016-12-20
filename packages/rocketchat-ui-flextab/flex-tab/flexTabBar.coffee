Template.flexTabBar.helpers
	active: ->
		return 'active' if @template is Sequoia.TabBar.getTemplate() and Sequoia.TabBar.isFlexOpen()
	buttons: ->
		return Sequoia.TabBar.getButtons()
	title: ->
		return t(@i18nTitle) or @title
	visible: ->
		if @groups.indexOf(Sequoia.TabBar.getVisibleGroup()) is -1
			return 'hidden'

Template.flexTabBar.events
	'click .tab-button': (e, t) ->
		e.preventDefault()

		if Sequoia.TabBar.isFlexOpen() and Sequoia.TabBar.getTemplate() is @template
			Sequoia.TabBar.closeFlex()
			$('.flex-tab').css('max-width', '')
			$('.main-content').css('right', '')
		else
			if not @openClick? or @openClick(e,t)
				if @width?
					$('.flex-tab').css('max-width', "#{@width}px")
					$('.main-content').css('right', "#{@width + 40}px")
				else
					$('.flex-tab').css('max-width', '')

				Sequoia.TabBar.setTemplate @template, ->
					$('.flex-tab')?.find("input[type='text']:first")?.focus()
					$('.flex-tab .content')?.scrollTop(0)

Template.flexTabBar.onCreated ->
	# close flex if the visible group changed and the opened template is not in the new visible group
	@autorun =>
		visibleGroup = Sequoia.TabBar.getVisibleGroup()

		Tracker.nonreactive =>
			openedTemplate = Sequoia.TabBar.getTemplate()
			exists = false
			Sequoia.TabBar.getButtons().forEach (button) ->
				if button.groups.indexOf(visibleGroup) isnt -1 and openedTemplate is button.template
					exists = true

			unless exists
				Sequoia.TabBar.closeFlex()
