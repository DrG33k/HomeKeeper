#!/bin/bash
fDOC="torrent $fDOC"

function torrent
{
  #Edit Here
  TORRENT_DIR="/home/transmission/automatic/"

  #Do not edit here
  MYNAME="${DOC_NAME%\"}"
  MYNAME="${MYNAME#\"}"
  MYTYPE="${MYNAME##*.}"
  if [ "$MYTYPE" == "torrent" ]; then
    echo " ! torrent -> "$TAKED_CHAT_ID

    MYFILEID="${DOC_ID%\"}"
    MYFILEID="${MYFILEID#\"}"

    RESULT=`curl -s -X POST https://api.telegram.org/bot$HASH/getFile?file_id=$MYFILEID`

    FILE_PATH=`echo $RESULT | jq '.result.file_path'`
    FILE_PATH="${FILE_PATH%\"}"
    FILE_PATH="${FILE_PATH#\"}"

    wget -O /tmp/$MYNAME https://api.telegram.org/file/bot$HASH/$FILE_PATH
    mv /tmp/$MYNAME $TORRENT_DIR
    TEXT="%F0%9F%90%BE $HOSTNAME alert!%0a"
    TEXT="$TEXT%E2%9E%96 %F0%9F%92%BE Downloading file: $MYNAME"
    /etc/telegram/send.sh $TAKED_CHAT_ID "$TEXT"
  fi
}
