// settings endpoints
Sequoia.API.v1.addRoute('settings/:_id', { authRequired: true }, {
	get() {
		if (!Sequoia.authz.hasPermission(this.userId, 'view-privileged-setting')) {
			return Sequoia.API.v1.unauthorized();
		}

		return Sequoia.API.v1.success(_.pick(Sequoia.models.Settings.findOneNotHiddenById(this.urlParams._id), '_id', 'value'));
	},
	post() {
		if (!Sequoia.authz.hasPermission(this.userId, 'edit-privileged-setting')) {
			return Sequoia.API.v1.unauthorized();
		}

		try {
			check(this.bodyParams, {
				value: Match.Any
			});

			if (Sequoia.models.Settings.updateValueNotHiddenById(this.urlParams._id, this.bodyParams.value)) {
				return Sequoia.API.v1.success();
			}

			return Sequoia.API.v1.failure();
		} catch (e) {
			return Sequoia.API.v1.failure(e.message);
		}
	}
});
