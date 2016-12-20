Sequoia.statistics.save = ->
	statistics = Sequoia.statistics.get()
	statistics.createdAt = new Date
	Sequoia.models.Statistics.insert statistics
	return statistics

