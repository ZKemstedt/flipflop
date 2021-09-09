#!/bin/sh
cd /spigot
pwd
YELLOW='\033[0;33m'
NC='\033[0m'
EULA=true

sed -i 's/false/true/g' eula.txt

/scripts/runserver.sh
