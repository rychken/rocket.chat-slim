blockedSettings = {}
process.env.SETTINGS_BLOCKED?.split(',').forEach (settingId) ->
	blockedSettings[settingId] = 1

hiddenSettings = {}
process.env.SETTINGS_HIDDEN?.split(',').forEach (settingId) ->
	hiddenSettings[settingId] = 1

Sequoia.settings._sorter = {}

###
# Add a setting
# @param {String} _id
# @param {Mixed} value
# @param {Object} setting
###
Sequoia.settings.add = (_id, value, options = {}) ->
	# console.log '[functions] Sequoia.settings.add -> '.green, 'arguments:', arguments

	if not _id or not value?
		return false

	Sequoia.settings._sorter[options.group] ?= 0

	options.packageValue = value
	options.valueSource = 'packageValue'
	options.hidden = false
	options.blocked = options.blocked || false
	options.sorter ?= Sequoia.settings._sorter[options.group]++

	if options.enableQuery?
		options.enableQuery = JSON.stringify options.enableQuery

	if options.i18nDefaultQuery?
		options.i18nDefaultQuery = JSON.stringify options.i18nDefaultQuery

	if process?.env?[_id]?
		value = process.env[_id]
		if value.toLowerCase() is "true"
			value = true
		else if value.toLowerCase() is "false"
			value = false
		options.processEnvValue = value
		options.valueSource = 'processEnvValue'

	else if Meteor.settings?[_id]?
		value = Meteor.settings[_id]
		options.meteorSettingsValue = value
		options.valueSource = 'meteorSettingsValue'

	if not options.i18nLabel?
		options.i18nLabel = _id

	# Default description i18n key will be the setting name + "_Description" (eg: LDAP_Enable -> LDAP_Enable_Description)
	if not options.i18nDescription?
		options.i18nDescription = "#{_id}_Description"

	if blockedSettings[_id]?
		options.blocked = true

	if hiddenSettings[_id]?
		options.hidden = true

	if process?.env?['OVERWRITE_SETTING_' + _id]?
		value = process.env['OVERWRITE_SETTING_' + _id]
		if value.toLowerCase() is "true"
			value = true
		else if value.toLowerCase() is "false"
			value = false
		options.value = value
		options.processEnvValue = value
		options.valueSource = 'processEnvValue'

	updateOperations =
		$set: options
		$setOnInsert:
			createdAt: new Date

	if not options.value?
		if options.force is true
			updateOperations.$set.value = options.packageValue
		else
			updateOperations.$setOnInsert.value = value

	query = _.extend { _id: _id }, updateOperations.$set

	if not options.section?
		updateOperations.$unset = { section: 1 }
		query.section = { $exists: false }

	if not Sequoia.models.Settings.findOne(query)?
		updateOperations.$set.ts = new Date
		return Sequoia.models.Settings.upsert { _id: _id }, updateOperations



###
# Add a setting group
# @param {String} _id
###
Sequoia.settings.addGroup = (_id, options = {}, cb) ->
	# console.log '[functions] Sequoia.settings.addGroup -> '.green, 'arguments:', arguments

	if not _id
		return false

	if _.isFunction(options)
		cb = options
		options = {}

	if not options.i18nLabel?
		options.i18nLabel = _id

	if not options.i18nDescription?
		options.i18nDescription = "#{_id}_Description"

	options.ts = new Date
	options.blocked = false
	options.hidden = false

	if blockedSettings[_id]?
		options.blocked = true

	if hiddenSettings[_id]?
		options.hidden = true

	Sequoia.models.Settings.upsert { _id: _id },
		$set: options
		$setOnInsert:
			type: 'group'
			createdAt: new Date

	if cb?
		cb.call
			add: (id, value, options = {}) ->
				options.group = _id
				Sequoia.settings.add id, value, options

			section: (section, cb) ->
				cb.call
					add: (id, value, options = {}) ->
						options.group = _id
						options.section = section
						Sequoia.settings.add id, value, options

	return


###
# Remove a setting by id
# @param {String} _id
###
Sequoia.settings.removeById = (_id) ->
	# console.log '[functions] Sequoia.settings.add -> '.green, 'arguments:', arguments

	if not _id
		return false

	return Sequoia.models.Settings.removeById _id


###
# Update a setting by id
# @param {String} _id
###
Sequoia.settings.updateById = (_id, value) ->
	# console.log '[functions] Sequoia.settings.updateById -> '.green, 'arguments:', arguments

	if not _id or not value?
		return false

	return Sequoia.models.Settings.updateValueById _id, value


###
# Update options of a setting by id
# @param {String} _id
###
Sequoia.settings.updateOptionsById = (_id, options) ->
	# console.log '[functions] Sequoia.settings.updateOptionsById -> '.green, 'arguments:', arguments

	if not _id or not options?
		return false

	return Sequoia.models.Settings.updateOptionsById _id, options


###
# Update a setting by id
# @param {String} _id
###
Sequoia.settings.clearById = (_id) ->
	# console.log '[functions] Sequoia.settings.clearById -> '.green, 'arguments:', arguments

	if not _id?
		return false

	return Sequoia.models.Settings.updateValueById _id, undefined


###
# Update a setting by id
###
Sequoia.settings.init = ->
	Sequoia.settings.initialLoad = true
	Sequoia.models.Settings.find().observe
		added: (record) ->
			Meteor.settings[record._id] = record.value
			if record.env is true
				process.env[record._id] = record.value
			Sequoia.settings.load record._id, record.value, Sequoia.settings.initialLoad
		changed: (record) ->
			Meteor.settings[record._id] = record.value
			if record.env is true
				process.env[record._id] = record.value
			Sequoia.settings.load record._id, record.value, Sequoia.settings.initialLoad
		removed: (record) ->
			delete Meteor.settings[record._id]
			if record.env is true
				delete process.env[record._id]
			Sequoia.settings.load record._id, undefined, Sequoia.settings.initialLoad
	Sequoia.settings.initialLoad = false

	for fn in Sequoia.settings.afterInitialLoad
		fn(Meteor.settings)


Sequoia.settings.afterInitialLoad = []

Sequoia.settings.onAfterInitialLoad = (fn) ->
	Sequoia.settings.afterInitialLoad.push(fn)
	if Sequoia.settings.initialLoad is false
		fn(Meteor.settings)
