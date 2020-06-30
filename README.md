# Plex Notifier

Small program to send Discord notifications when plex webhook sends events.

Here is the Plex docs about webhooks: https://support.plex.tv/articles/115002267687-webhooks/

**Supported events:**
- media.play
- media.pause
- media.resume
- media.stop
- media.scrobble
- library.new

## Notification examples

### media.play

![media.play notification](.github/readme-assets/media-play.png?raw=true "media.play notification")

### media.resume

![media.resume notification](.github/readme-assets/media-resume.png?raw=true "media.resume notification")

### library.new

![library.new notification](.github/readme-assets/library-new.png?raw=true "library.new notification")

---

## Setting up the bot

### Register your plex webhook

First, your need to add a webhook URL in your Plex account settings (a PlexPass suscription is required):

![Settings Webhooks](.github/readme-assets/plex-webhook.png?raw=true "Settings Webhooks")

![Settings Webhooks Add](.github/readme-assets/plex-webhook-add.png?raw=true "Settings Webhooks Add")

The URL has to match this format `http(s)://<your-server-ip>/plex`.

Then in order to enable the `library.new` notifications, you need to enable push notifications on your Plex server settings.

![Enable Push Notifications](.github/readme-assets/plex-push-notif.png?raw=true "Enable Push Notifications")

### Install the Discord bot

Hit this URL `http://<your-server-ip>/discord` in your browser, this will redirect you to the Discord page to authorize and install the bot.

---

## Starting the notifier

**REQUIRED ENVIRONMENT VARIABLES:**
- **HOST_URL**: Points to this program. This is used by Discord to get posters, hosted here in `/images`.
- **DISCORD_GUILD_ID**: Is your Discord Guild ID.

You can find it by right-clicking on your discord server, then:

![Discord Guild ID](.github/readme-assets/discord-guild-id.png?raw=true "Discord Guild ID")

```bash
# Getting the help
$> server -h
    --[no-]media      Enable plex media.* events.
                      (defaults to on)
    --[no-]library    Enable plex library.new event.
                      (defaults to on)
-v, --verbose         Add more logging.
-h, --help
```

### Using Docker image:

```bash
$> docker run -e DISCORD_GUILD_ID="<your-guild-id>" -e HOST_URL="http(s)://<your-server-ip>" -p 8080:5000 arinono/plex-notifier [arguments]
```

### Manually

_Coming soon, I need to add binary to releases._

---

## Development or use your own Discord Bot

If you want to start the project locally, or build it to use your own Discord bot you can:

```bash
# Start locally
$> HOST_URL="http(s)://<your-server-ip>" DISCORD_GUILD_ID="<your-guild-id>" dart -DPORT="8080" -DDISCORD_CLIENT_ID="<your-discord-app-id>" -DDISCORD_BOT_TOKEN="<your-discord-bot-token>" bin/main.dart

# Build the executable
$> dart2native -DPORT="5000" -DDISCORD_CLIENT_ID="<your-discord-app-id>" -DDISCORD_BOT_TOKEN="<your-discord-bot-token>" bin/main.dart -o build/server

# or build the Docker image
$> docker build --build-arg DISCORD_BOT_TOKEN="<your-discord-bot-token>" --build-arg DISCORD_CLIENT_ID="<your-discord-app-id>" -t <your-tag> .
```

---

## TODO and ideas

Todo:
- [ ] Automate release process and release the v1.0.0
- [ ] Write some tests and add CI pipelines
- [ ] Document the code
- [ ] Error managment coming from Discord (gateway error reconnect and resume connection on error)

Ideas:
- [ ] Maybe add support for other tools (slack, ...)
- [ ] Maybe add a way for Discord users to subscribe to `library.on.deck` notifications.
- [ ] Publish the bot [here](https://top.gg/) ?
