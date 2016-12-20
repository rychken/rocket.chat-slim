Mailer.unsubscribe = (_id, createdAt) ->
	if _id and createdAt
		return Sequoia.models.Users.RocketMailUnsubscribe(_id, createdAt) == 1
	return false
