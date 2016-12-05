#!/bin/bash
OWNER=$1
TEXT=$2
source /etc/telegram/.config
curl -s --max-time 10 -d "chat_id=$OWNER&text=$TEXT" https://api.telegram.org/bot$HASH/sendMessage > /dev/null
