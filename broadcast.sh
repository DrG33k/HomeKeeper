#!/bin/bash
TEXT=$1
source /etc/telegram/.owners
source /etc/telegram/.config
for OWNER in ${OWNERS[@]}; do
  curl -s --max-time 10 -d "chat_id=$OWNER&text=$TEXT" https://api.telegram.org/bot$HASH/sendMessage > /dev/null
done
