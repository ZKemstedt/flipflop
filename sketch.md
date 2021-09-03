alright så med lite sketching...

# Projektplan (sketch)

## Minecraft Server
Running the [Spigot](https://www.spigotmc.org/) high performance minecraft server
Additional pluggins are used and they are listed further below.

## Docker
We will use Docker (docker-compose) to build and deploy our images.

inspiration from [here](https://github.com/itzg/docker-minecraft-server#using-docker-compose)


## Plugins

### Primary plugins
* Dynmap [link](https://www.spigotmc.org/resources/dynmap.274/)
  > A Google Maps-like map for your Minecraft server that can be viewed in a browser.

  We will be hosting a webbserver to show this off

* CoreProtect [link](https://www.spigotmc.org/resources/coreprotect.8631/)
  > CoreProtect is a fast, efficient, data logging and anti-griefing tool. Rollback and restore any amount of damage. Designed with large servers in mind, CoreProtect will record and manage data without impacting your server performance.

  Loggs will be stored in a database


### Secondary plugins
* DiscordSRV
  [link](https://www.spigotmc.org/resources/discordsrv.18494/)
  > Using this plugin, you are able to give players the ability to chat in-game to chat with players on your Discord server as well as having people on the Discord server be able to chat with people on the server- this is useful for the situation of someone not being at their computer and being able to talk in-game.
  > As well as that, this plugin also has a remote console feature. 
