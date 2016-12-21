FlowRouter.goToRoomById = (roomId) => {
	const subscription = ChatSubscription.findOne({rid: roomId});
	if (subscription) {
		FlowRouter.go(Sequoia.roomTypes.getRouteLink(subscription.t, subscription), null, FlowRouter.current().queryParams);
	}
};
