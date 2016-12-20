//
// AutoLinker is a named function that will replace links on messages
// @param {Object} message - The message object
//

import Autolinker from 'autolinker';

function AutoLinker(message) {
	if (_.trim(message.html)) {
		const regUrls = new RegExp(Sequoia.settings.get('AutoLinker_UrlsRegExp'));

		const autolinker = new Autolinker({
			stripPrefix: Sequoia.settings.get('AutoLinker_StripPrefix'),
			urls: {
				schemeMatches: Sequoia.settings.get('AutoLinker_Urls_Scheme'),
				wwwMatches: Sequoia.settings.get('AutoLinker_Urls_www'),
				tldMatches: Sequoia.settings.get('AutoLinker_Urls_TLD')
			},
			email: Sequoia.settings.get('AutoLinker_Email'),
			phone: Sequoia.settings.get('AutoLinker_Phone'),
			twitter: false,
			replaceFn(match) {
				if (match.getType() === 'url') {
					if (regUrls.test(match.matchedText)) {
						if (match.matchedText.indexOf(Meteor.absoluteUrl()) === 0) {
							const tag = match.buildTag();				// returns an `Autolinker.HtmlTag` instance for an <a> tag
							tag.setAttr('target', '');					// sets target to empty, instead of _blank
							return tag;
						}

						return true;
					}
				}

				return null;
			}
		});

		let regNonAutoLink = /(```\w*[\n ]?[\s\S]*?```+?)|(`(?:[^`]+)`)/;
		if (Sequoia.settings.get('Katex_Enabled')) {
			regNonAutoLink = /(```\w*[\n ]?[\s\S]*?```+?)|(`(?:[^`]+)`)|(\\\(\w*[\n ]?[\s\S]*?\\\)+?)/;
		}

		// Separate text in code blocks and non code blocks
		const msgParts = message.html.split(regNonAutoLink);

		msgParts.forEach((part, index) => {
			if (part && part.length > 0) {
				// Verify if this part is code
				const codeMatch = part.match(regNonAutoLink);
				if (!codeMatch) {
					msgParts[index] = autolinker.link(part);
				}
			}
		});

		// Re-mount message
		message.html = msgParts.join('');
	}

	return message;
}

Sequoia.callbacks.add('renderMessage', AutoLinker);
