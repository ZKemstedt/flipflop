
# Scenario:

Build development and production environments for a simple application
* OS: Linux
* Git
* Any webbserver
* Any database
* Come up with or Assume what else might be required

Make a draft of how the environments should be set up and how deployment from test should be handled.
* Show how you manage users in respective environment
* Deployment should be automized to a relevant degree
* Some form of monitoring should be in place for relevant programs during production



# Projektplan (sketch)

## Application: Minecraft Server
Running the [Spigot](https://www.spigotmc.org/) high performance minecraft server  
Additional pluggins are used and they are listed further below.

## Deployment: Docker
We will use Docker (docker-compose) to build and deploy our environments.  
inspiration from [here](https://github.com/itzg/docker-minecraft-server#using-docker-compose)

## Webbserver: *(tool pending)*
We will be hosting a webbserver to show off a live world map of the game using a plugin  
**Dynmap** [link](https://www.spigotmc.org/resources/dynmap.274/)
> A Google Maps-like map for your Minecraft server that can be viewed in a browser.

## Database: *(tool pending)* & *(partial)* Monitoring
We will log users activity within the server using a plugin and these logs will be stored in a database  
Also allows rollback/restores of activity
**CoreProtect** [link](https://www.spigotmc.org/resources/coreprotect.8631/)
> CoreProtect is a fast, efficient, data logging and anti-griefing tool. Rollback and restore any amount of damage. Designed with large servers in mind, CoreProtect will record and manage data without impacting your server performance.


## Additional Monitoring... 
extra log-scripts on crontab ?

## About Users... 
*Show how you manage users in respective environment* they said, but what kind of users do we manage? I assume the players? is that enough? do we need to manage other kinds of users?  
the mc-server would specify whitelisted and privileged users respectively from textfiles


## Additional ideas...

* *plugin* **DiscordSRV**
  [link](https://www.spigotmc.org/resources/discordsrv.18494/)
  > Using this plugin, you are able to give players the ability to chat in-game to chat with players on your Discord server as well as having people on the Discord server be able to chat with people on the server- this is useful for the situation of someone not being at their computer and being able to talk in-game.
  > As well as that, this plugin also has a remote console feature. 


<!-- some notes

More related works by this itzg guy

MC Server Status Monitoring (can export to prometheus)
https://github.com/itzg/mc-monitor

Provide routing to different servers ?
https://github.com/itzg/mc-router

Backup management
https://github.com/itzg/docker-mc-backup

A process wrapper used by the itzg/minecraft-server Docker image to enable gracefull server stop when container receives TERM signal.
https://github.com/itzg/mc-server-runner


 -->