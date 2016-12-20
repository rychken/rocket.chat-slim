Sequoia.authz.cachedCollection = new Sequoia.CachedCollection({ name: 'permissions', eventType: 'onAll', initOnLogin: true })
@ChatPermissions = Sequoia.authz.cachedCollection.collection
