FlowRouter.route '/admin/users',
	name: 'admin-users'
	action: ->
		Sequoia.TabBar.showGroup 'adminusers'
		BlazeLayout.render 'main', {center: 'adminUsers'}

FlowRouter.route '/admin/rooms',
	name: 'admin-rooms'
	action: ->
		Sequoia.TabBar.showGroup 'adminrooms'
		BlazeLayout.render 'main', {center: 'adminRooms'}

FlowRouter.route '/admin/info',
	name: 'admin-info'
	action: ->
		Sequoia.TabBar.showGroup 'adminInfo'
		BlazeLayout.render 'main', {center: 'adminInfo'}

FlowRouter.route '/admin/import',
	name: 'admin-import'
	action: ->
		BlazeLayout.render 'main', {center: 'adminImport'}

FlowRouter.route '/admin/import/prepare/:importer',
	name: 'admin-import-prepare'
	action: ->
		BlazeLayout.render 'main', {center: 'adminImportPrepare'}

FlowRouter.route '/admin/import/progress/:importer',
	name: 'admin-import-progress'
	action: ->
		BlazeLayout.render 'main', {center: 'adminImportProgress'}

FlowRouter.route '/admin/:group?',
	name: 'admin'
	action: ->
		Sequoia.TabBar.showGroup 'admin'
		BlazeLayout.render 'main', {center: 'admin'}
