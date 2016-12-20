Meteor.methods
	checkRegistrationSecretURL: (hash) ->

		check hash, String

		return hash is Sequoia.settings.get 'Accounts_RegistrationForm_SecretURL'
