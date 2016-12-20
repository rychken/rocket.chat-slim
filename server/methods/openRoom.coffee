Meteor.methods
  openRoom: (rid) ->

    check rid, String

    if not Meteor.userId()
      throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'openRoom' }

    Sequoia.models.Subscriptions.openByRoomIdAndUserId rid, Meteor.userId()
