# https://github.com/TelescopeJS/Telescope/blob/master/packages/telescope-lib/lib/callbacks.js

###
# Callback hooks provide an easy way to add extra steps to common operations.
# @namespace Sequoia.callbacks
###
Sequoia.callbacks = {}

if Meteor.isServer
	Sequoia.callbacks.showTime = true
	Sequoia.callbacks.showTotalTime = true
else
	Sequoia.callbacks.showTime = false
	Sequoia.callbacks.showTotalTime = false

###
# Callback priorities
###
Sequoia.callbacks.priority =
	HIGH: -1000
	MEDIUM: 0
	LOW: 1000

###
# Add a callback function to a hook
# @param {String} hook - The name of the hook
# @param {Function} callback - The callback function
###
Sequoia.callbacks.add = (hook, callback, priority, id) ->
	# if callback array doesn't exist yet, initialize it
	priority ?= Sequoia.callbacks.priority.MEDIUM
	unless _.isNumber priority
		priority = Sequoia.callbacks.priority.MEDIUM
	callback.priority = priority
	callback.id = id or Random.id()
	Sequoia.callbacks[hook] ?= []

	if Sequoia.callbacks.showTime is true
		err = new Error
		callback.stack = err.stack

		# if not id?
		# 	console.log('Callback without id', callback.stack)

	# Avoid adding the same callback twice
	for cb in Sequoia.callbacks[hook]
		if cb.id is callback.id
			return

	Sequoia.callbacks[hook].push callback
	return

###
# Remove a callback from a hook
# @param {string} hook - The name of the hook
# @param {string} id - The callback's id
###

Sequoia.callbacks.remove = (hookName, id) ->
	Sequoia.callbacks[hookName] = _.reject Sequoia.callbacks[hookName], (callback) ->
		callback.id is id
	return

###
# Successively run all of a hook's callbacks on an item
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
# @returns {Object} Returns the item after it's been through all the callbacks for this hook
###

Sequoia.callbacks.run = (hook, item, constant) ->
	callbacks = Sequoia.callbacks[hook]
	if !!callbacks?.length
		if Sequoia.callbacks.showTotalTime is true
			totalTime = 0

		# if the hook exists, and contains callbacks to run
		result = _.sortBy(callbacks, (callback) -> return callback.priority or Sequoia.callbacks.priority.MEDIUM).reduce (result, callback) ->
			# console.log(callback.name);
			if Sequoia.callbacks.showTime is true or Sequoia.callbacks.showTotalTime is true
				time = Date.now()

			callbackResult = callback result, constant

			if Sequoia.callbacks.showTime is true or Sequoia.callbacks.showTotalTime is true
				currentTime = Date.now() - time
				totalTime += currentTime
				if Sequoia.callbacks.showTime is true
					if Meteor.isServer
						Sequoia.statsTracker.timing('callbacks.time', currentTime, ["hook:#{hook}", "callback:#{callback.id}"]);
					else
						console.log String(currentTime), hook, callback.id, callback.stack?.split?('\n')[2]?.match(/\(.+\)/)?[0]

			return callbackResult
		, item

		if Sequoia.callbacks.showTotalTime is true
			if Meteor.isServer
				Sequoia.statsTracker.timing('callbacks.totalTime', totalTime, ["hook:#{hook}"]);
			else
				console.log hook+':', totalTime

		return result
	else
		# else, just return the item unchanged
		return item

###
# Successively run all of a hook's callbacks on an item, in async mode (only works on server)
# @param {String} hook - The name of the hook
# @param {Object} item - The post, comment, modifier, etc. on which to run the callbacks
# @param {Object} [constant] - An optional constant that will be passed along to each callback
###

Sequoia.callbacks.runAsync = (hook, item, constant) ->
	callbacks = Sequoia.callbacks[hook]
	if Meteor.isServer and !!callbacks?.length
		# use defer to avoid holding up client
		Meteor.defer ->
			# run all post submit server callbacks on post object successively
			_.sortBy(callbacks, (callback) -> return callback.priority or Sequoia.callbacks.priority.MEDIUM).forEach (callback) ->
				# console.log(callback.name);
				callback item, constant
				return
			return
	else
		return item
	return
