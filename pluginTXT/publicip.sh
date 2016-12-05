
#!/bin/bash
fTXT="publicip $fTXT"

function publicip
{
  if [ "$1" == "\"mio ip\"" ]; then
    echo " ! myIP -> "$TAKED_CHAT_ID
    /etc/telegram/send.sh $TAKED_CHAT_ID `curl -s ipinfo.io/ip`
  fi
}
