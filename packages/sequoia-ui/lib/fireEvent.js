window.fireGlobalEvent = (eventName, params) => {
	window.dispatchEvent(new CustomEvent(eventName, {detail: params}));

	if (Sequoia.settings.get('Iframe_Integration_send_enable') === true) {
		parent.postMessage({
			eventName: eventName,
			data: params
		}, Sequoia.settings.get('Iframe_Integration_send_target_origin'));
	}
};
