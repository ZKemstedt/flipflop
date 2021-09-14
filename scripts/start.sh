#!/bin/bash
exec java \
-Xms${XMS} \
-Xmx${XMX} \
-XX:+UseG1GC \
-XX:+ParallelRefProcEnabled \
-XX:MaxGCPauseMillis=200 \
-XX:+UnlockExperimentalVMOptions \
-XX:+DisableExplicitGC \
-XX:+AlwaysPreTouch \
-XX:G1NewSizePercent=40 \
-XX:G1MaxNewSizePercent=50 \
-XX:G1HeapRegionSize=16M \
-XX:G1ReservePercent=15 \
-XX:G1HeapWastePercent=5 \
-XX:G1MixedGCCountTarget=4 \
-XX:InitiatingHeapOccupancyPercent=20 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1RSetUpdatingPauseTimePercent=5 \
-XX:SurvivorRatio=32 \
-XX:+PerfDisableSharedMem \
-XX:MaxTenuringThreshold=1 \
-jar /data/spigot.jar nogui 

# GC = Garbage Collection
# -Xms${XMS} \ # min ram usage
# -Xmx${XMX} \ # max ram usage
# -XX:+UseG1GC \ 
# -XX:+ParallelRefProcEnabled \
# -XX:MaxGCPauseMillis=200 \ # goal for how long the server should pause gc
# -XX:+UnlockExperimentalVMOptions \ # needed for some of the flags
# -XX:+DisableExplicitGC \ # so that plugins wont trigger full gc
# -XX:+AlwaysPreTouch \
# -XX:G1NewSizePercent=40 \
# -XX:G1MaxNewSizePercent=50 \
# -XX:G1HeapRegionSize=16M \ # 
# -XX:G1ReservePercent=15 \ # to keep some free space to be able to move data around
# -XX:G1HeapWastePercent=5 \
# -XX:G1MixedGCCountTarget=4 \
# -XX:InitiatingHeapOccupancyPercent=20 \
# -XX:G1MixedGCLiveThresholdPercent=90 \
# -XX:G1RSetUpdatingPauseTimePercent=5 \
# -XX:SurvivorRatio=32 \
# -XX:+PerfDisableSharedMem \
# -XX:MaxTenuringThreshold=1 \
# -Dusing.aikars.flags=https://mcflags.emc.gs \ # I think these are just for aikar shoutout
# -Daikars.new.flags=true \
# -jar /data/spigot.jar nogui # specify server jar, run with no gui