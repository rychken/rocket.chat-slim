## Rocket.Chat main library

This package contains the main libraries of Rocket.Chat.

### APIs

#### Settings

This is an example to create settings:
```javascript
Sequoia.settings.addGroup('Settings_Group', function() {
    this.add('SettingInGroup', 'default_value', { type: 'boolean', public: true });

    this.section('Group_Section', function() {
        this.add('Setting_Inside_Section', 'default_value', {
            type: 'boolean',
            public: true,
            enableQuery: { 
                _id: 'SettingInGroup', 
                value: true 
            }
        });
    });
});
```

`Sequoia.settings.add` type:

* `string` - Stores a string value
    * Additional options:
        * `multiline`: boolean
* `int` - Stores an integer value
* `boolean` - Stores a boolean value
* `select` - Creates an `<select>` element
    * Additional options:
        * `values`: Array of: { key: 'value', i18nLabel: 'Option_Label' }
* `color` - Creates a color pick element
* `action` - Executes a `Method.call` to `value`
    * Additional options:
        * `actionText`: Translatable value of the button
* `asset` - Creates an upload field

`Sequoia.settings.add` options:

* `description` - Description of the setting
* `public` - Boolean to set if the setting should be sent to client or not
* `enableQuery` - Only enable this setting if the correspondent setting has the value specified
* `alert` - Shows an alert message with the given text

#### roomTypes

You can create your own room type using (on the client):

```javascript
Sequoia.roomTypes.add('l', 5, {
    template: 'livechat',
    icon: 'icon-chat-empty',
    route: {
        name: 'live',
        path: '/live/:name',
        action(params, queryParams) {
            Session.set('showUserInfo');
            openRoom('l', params.name);
        },
        link(sub)  {
            return { name: sub.name }
        }
    },
    condition: () => {
        return Sequoia.authz.hasAllPermission('view-l-room');
    }
});
```

You'll need publish information about the new room with (on the server):

```javascript
Sequoia.roomTypes.setPublish('l', (identifier) => {
    return Sequoia.models.Rooms.findByTypeAndName('l', identifier, {
        fields: {
            name: 1,
            t: 1,
            cl: 1,
            u: 1,
            usernames: 1,
            v: 1
        }
    });
});
```

### AccountBox

You can add items to the left upper corner drop menu:
```javascript
AccountBox.addItem({
    name: 'Livechat',
    icon: 'icon-chat-empty',
    class: 'livechat-manager',
    condition: () => {
        return Sequoia.authz.hasAllPermission('view-livechat-manager');
    }
});
```

### Functions
### Methods
### Publications
