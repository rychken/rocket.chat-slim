@ChatMessage = new Meteor.Collection null
@ChatRoom = new Meteor.Collection 'rocketchat_room'

@CachedChatSubscription = new Sequoia.CachedCollection({ name: 'subscriptions', initOnLogin: true })
@ChatSubscription = CachedChatSubscription.collection
@UserRoles = new Mongo.Collection null
@RoomRoles = new Mongo.Collection null
@UserAndRoom = new Meteor.Collection null
@CachedChannelList = new Meteor.Collection null
@CachedUserList = new Meteor.Collection null

Sequoia.models.Users = _.extend {}, Sequoia.models.Users, Meteor.users
Sequoia.models.Subscriptions = _.extend {}, Sequoia.models.Subscriptions, @ChatSubscription
Sequoia.models.Rooms = _.extend {}, Sequoia.models.Rooms, @ChatRoom
Sequoia.models.Messages = _.extend {}, Sequoia.models.Messages, @ChatMessage
