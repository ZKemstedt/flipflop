#!/bin/bash

YELLOW='\033[0;33m'
NC='\033[0m'
EULA=true

# if eula.txt does not exist, then generate it first
echo -e "Start running script... EULA is ${EULA}"

if [ ! "$EULA" = true ]
then exit
fi

if [ ! -f eula.txt ];
then
  echo -e "${YELLOW}Initialize server files...${NC}"
  /scripts/runserver.sh
fi

echo -e "${YELLOW}Setting EULA to true...${NC}"
sed -i 's/false/true/g' eula.txt

echo -e "${YELLOW}Starting server...${NC}"
/scripts/runserver.sh
