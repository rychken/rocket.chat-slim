Meteor.methods
	sendInvitationEmail: (emails) ->

		check emails, [String]

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'sendInvitationEmail' }

		unless Sequoia.authz.hasRole(Meteor.userId(), 'admin')
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'sendInvitationEmail' }

		rfcMailPattern = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
		validEmails = _.compact _.map emails, (email) -> return email if rfcMailPattern.test email

		header = Sequoia.placeholders.replace(Sequoia.settings.get('Email_Header') || "")
		footer = Sequoia.placeholders.replace(Sequoia.settings.get('Email_Footer') || "")

		if Sequoia.settings.get('Invitation_Customized')
			subject = Sequoia.settings.get('Invitation_Subject')
			html = Sequoia.settings.get('Invitation_HTML')
		else
			subject = TAPi18n.__('Invitation_Subject_Default', { lng: Meteor.user()?.language || Sequoia.settings.get('language') || 'en' })
			html = TAPi18n.__('Invitation_HTML_Default', { lng: Meteor.user()?.language || Sequoia.settings.get('language') || 'en' })

		subject = Sequoia.placeholders.replace(subject);

		for email in validEmails
			@unblock()

			html = Sequoia.placeholders.replace(html, { email: email });

			try
				Email.send
					to: email
					from: Sequoia.settings.get 'From_Email'
					subject: subject
					html: header + html + footer
			catch error
				throw new Meteor.Error 'error-email-send-failed', 'Error trying to send email: ' + error.message, { method: 'sendInvitationEmail', message: error.message }


		return validEmails
