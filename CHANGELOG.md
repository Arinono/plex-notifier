# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [2.0.2](https://github.com/Arinono/plex-notifier/compare/2.0.1...2.0.2) (2020-07-24)

### [2.0.1](https://github.com/Arinono/plex-notifier/compare/2.0.0...2.0.1) (2020-07-24)


### Bug Fixes

* **dockerfile:** add mkdir /images ([6fd32c4](https://github.com/Arinono/plex-notifier/commit/6fd32c418bf46fbedfaa4bd1a0411488a93a98bb))

## [2.0.0](https://github.com/Arinono/plex-notifier/compare/1.0.1...2.0.0) (2020-07-24)


### Bug Fixes

* **create-plex-channel:** wait for the bot to have access ([0c8c6c3](https://github.com/Arinono/plex-notifier/commit/0c8c6c356f089c322ed511472938941042967054)), closes [#5](https://github.com/Arinono/plex-notifier/issues/5)
* **notif:** fix error when creating a notification ([a5e11f9](https://github.com/Arinono/plex-notifier/commit/a5e11f9698b46314342d1586b4e67c7b5c58725e)), closes [#2](https://github.com/Arinono/plex-notifier/issues/2)
* **plex-controller:** fix typo ([16935e7](https://github.com/Arinono/plex-notifier/commit/16935e75267b6f0ac82d538f6c69e4cfc82cbb4b))

### BREAKING CHANGES

* Change **HOST_URL** environment variable to **SELF_DOMAIN**
* Change **DISCORD_GUILD_ID** environment variable to **DISCORD_CHANNEL_ID**

### [1.0.1](https://github.com/Arinono/plex-notifier/compare/1.0.0...1.0.1) (2020-06-30)


### Bug Fixes

* **docker:** install curl final docker image for healthcheck ([ce18135](https://github.com/Arinono/plex-notifier/commit/ce18135f2dae4f3261c7f1cbc45fe596e3e0f8a8))

# 1.0.0 (2020-06-30)


### Bug Fixes

* **main:** fix POSIX event handlers ([253639c](https://github.com/Arinono/plex-notifier/commit/253639ce40522c2d8b7ddf77418b311b8864f08a))


### Features

* **main:** add arguments to cli ([d5c915f](https://github.com/Arinono/plex-notifier/commit/d5c915f02399df767f423b8524dad78c35edc0c1))
* **plex-notif:** add media.scrobble event handler ([6a0d8d2](https://github.com/Arinono/plex-notifier/commit/6a0d8d2695a01f0ca0693e531b65e2854fee561c))
* **plex-notif:** add support for library.new event ([0fc575b](https://github.com/Arinono/plex-notifier/commit/0fc575b39a706a45cff39266ede7b62cd5e2267d))
* send discord notification when plex webhook event is fired ([09daa0b](https://github.com/Arinono/plex-notifier/commit/09daa0b5e92236fc1d9fb8762b493434b2433ef2))
