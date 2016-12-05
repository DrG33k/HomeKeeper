
#!/bin/bash
fTXT="ping $fTXT"

function ping
{
  if [ "$1" == "\"ping\"" ]; then
    echo " ! pong -> "$TAKED_CHAT_ID
    /etc/telegram/send.sh $TAKED_CHAT_ID "pong"
  fi
}
