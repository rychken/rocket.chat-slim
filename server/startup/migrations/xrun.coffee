if Sequoia.Migrations.getVersion() isnt 0
	Sequoia.Migrations.migrateTo 'latest'
else
	control = Sequoia.Migrations._getControl()
	control.version = _.last(Sequoia.Migrations._list).version
	Sequoia.Migrations._setControl control
