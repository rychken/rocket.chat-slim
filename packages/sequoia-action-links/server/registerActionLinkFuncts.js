//Action Links namespace creation.

Sequoia.actionLinks = {
	register : function(name, funct) {
		Sequoia.actionLinks[name] = funct;
	}
};
