###
# Sequoia.settings holds all packages settings
# @namespace Sequoia.settings
###

Sequoia.settings.cachedCollection = new Sequoia.CachedCollection({ name: 'public-settings', eventType: 'onAll' })
Sequoia.settings.collection = Sequoia.settings.cachedCollection.collection
Sequoia.settings.cachedCollection.init()

Sequoia.settings.dict = new ReactiveDict 'settings'

Sequoia.settings.get = (_id) ->
	return Sequoia.settings.dict.get(_id)

Sequoia.settings.init = ->
	initialLoad = true
	Sequoia.settings.collection.find().observe
		added: (record) ->
			Meteor.settings[record._id] = record.value
			Sequoia.settings.dict.set record._id, record.value
			Sequoia.settings.load record._id, record.value, initialLoad
		changed: (record) ->
			Meteor.settings[record._id] = record.value
			Sequoia.settings.dict.set record._id, record.value
			Sequoia.settings.load record._id, record.value, initialLoad
		removed: (record) ->
			delete Meteor.settings[record._id]
			Sequoia.settings.dict.set record._id, undefined
			Sequoia.settings.load record._id, undefined, initialLoad
	initialLoad = false

Sequoia.settings.init()

Meteor.startup ->
	if Meteor.isCordova is false
		Tracker.autorun (c) ->
			siteUrl = Sequoia.settings.get('Site_Url')
			if not siteUrl or not Meteor.userId()?
				return

			if Sequoia.authz.hasRole(Meteor.userId(), 'admin') is false or Meteor.settings.public.sandstorm
				return c.stop()

			Meteor.setTimeout ->
				if __meteor_runtime_config__.ROOT_URL isnt location.origin
					currentUrl = location.origin + __meteor_runtime_config__.ROOT_URL_PATH_PREFIX
					swal
						type: 'warning'
						title: t('Warning')
						text: t("The_setting_s_is_configured_to_s_and_you_are_accessing_from_s", t('Site_Url'), siteUrl, currentUrl) + '<br/><br/>' + t("Do_you_want_to_change_to_s_question", currentUrl)
						showCancelButton: true
						confirmButtonText: t('Yes')
						cancelButtonText: t('Cancel')
						closeOnConfirm: false
						html: true
					, ->
						Meteor.call 'saveSetting', 'Site_Url', currentUrl, ->
							swal
								title: t('Saved')
								type: 'success'
								timer: 1000
								showConfirmButton: false
			, 100

			return c.stop()
