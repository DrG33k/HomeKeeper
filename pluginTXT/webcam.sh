#!/bin/bash
fTXT="webcam $fTXT"

function webcam
{
  #Edit Here
  WEBCAM01_NAME="salotto"
  WEBCAM01_IP="192.168.1.220"
  WEBCAM01_USER="admin"
  WEBCAM01_PASSWORD="password"

  WEBCAM02_NAME="ingresso"
  WEBCAM02_IP="192.168.1.221"
  WEBCAM02_USER="admin"
  WEBCAM02_PASSWORD="password"

  #Do not edit here
  if [ "$1" == \"$WEBCAM01_NAME\" ]; then
    echo " ! webcam $WEBCAM01_NAME -> "$TAKED_CHAT_ID
    if [ -f "/tmp/$WEBCAM01_NAME.jpg" ]; then
      rm /tmp/$WEBCAM01_NAME.jpg
    fi
    wget --user $WEBCAM01_USER --password $WEBCAM01_PASSWORD http://$WEBCAM01_IP/image/jpeg.cgi -O /tmp/$WEBCAM01_NAME.jpg
    if [ -f "/tmp/$WEBCAM01_NAME.jpg" ]; then
      curl -s -X POST "https://api.telegram.org/bot$HASH/sendPhoto" \
        -F chat_id=$TAKED_CHAT_ID \
        -F reply_to_message_id=$TAKED_MESSAGE_ID \
        -F photo="@/tmp/$WEBCAM01_NAME.jpg" > /dev/null
      rm /tmp/$WEBCAM01_NAME.jpg
    fi
  fi
  if [ "$1" == \"$WEBCAM02_NAME\" ]; then
    echo " ! webcam $WEBCAM02_NAME -> "$TAKED_CHAT_ID
    if [ -f "/tmp/$WEBCAM02_NAME.jpg" ]; then
      rm /tmp/$WEBCAM02_NAME.jpg
    fi
    wget --user $WEBCAM02_USER --password $WEBCAM02_PASSWORD http://$WEBCAM02_IP/image/jpeg.cgi -O /tmp/$WEBCAM02_NAME.jpg
    if [ -f "/tmp/$WEBCAM02_NAME.jpg" ]; then
      curl -s -X POST "https://api.telegram.org/bot$HASH/sendPhoto" \
        -F chat_id=$TAKED_CHAT_ID \
        -F reply_to_message_id=$TAKED_MESSAGE_ID \
        -F photo="@/tmp/$WEBCAM02_NAME.jpg" > /dev/null
      rm /tmp/$WEBCAM02_NAME.jpg
    fi
  fi
}
