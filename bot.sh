#!/bin/bash
source /etc/telegram/.owners
source /etc/telegram/.config

function vCheckAdmin {
  IS_ADMIN=false
  for OWNR in ${OWNERS[@]}; do
    if [ "$OWNR" == "$1" ]; then
      IS_ADMIN=true
    fi
  done
}

fTXT=" "
fDOC=" "
fLOC=" "
fIMG=" "

CARTELLE=("/etc/telegram/pluginTXT" "/etc/telegram/pluginDOC" "/etc/telegram/pluginLOC" "/etc/telegram/pluginIMG")
for CARTELLA in ${CARTELLE[@]}; do
  if [ -d "$CARTELLA" ]; then
    for file in $CARTELLA/*; do
      echo " + "$file
      source $file
    done
  fi
done

RESULT=`curl -s -X POST https://api.telegram.org/bot$HASH/getUpdates`
#echo "$RESULT"
LAST_UPDATE=0
NEXT_UPDATE=0
while true; do
  RESULT=`curl -s -X POST https://api.telegram.org/bot$HASH/getUpdates?timeout=180'&'offset=$NEXT_UPDATE`
#  echo "$RESULT"

  TAKED_UPDATE=`echo $RESULT | jq '.result[-1].update_id'`
  if [ "$TAKED_UPDATE" != "null" ]; then
#    echo "C'è almeno un messaggio"
    if [ "$TAKED_UPDATE" -ne "$LAST_UPDATE" ]; then
#      echo "$RESULT"
#      echo "Messaggio non ancora interpretato"
      LAST_UPDATE=$TAKED_UPDATE
      NEXT_UPDATE=$((LAST_UPDATE+1))
      TAKED_FROM_ID=`echo $RESULT | jq '.result[-1].message.from.id'`
      TAKED_CHAT_ID=`echo $RESULT | jq '.result[-1].message.chat.id'`
      TAKED_MESSAGE_ID=`echo $RESULT | jq '.result[-1].message.message_id'`
      TAKED_MSG=`echo $RESULT | jq '.result[-1].message.text'`
      vCheckAdmin $TAKED_FROM_ID
      if [ "$IS_ADMIN" = true ]; then
#        echo "Sono admin"
        TAKED_IMG=`echo $RESULT | jq '.result[-1].message.photo'`
        TAKED_LOC=`echo $RESULT | jq '.result[-1].message.location'`
        TAKED_DOC=`echo $RESULT | jq '.result[-1].message.document'`
        if [ "$TAKED_IMG" != "null" ]; then
#          echo "Ho una immagine"
          IMG_ID=`echo $RESULT | jq '.result[-1].message.photo[0].file_id'`
          IMG_SIZE=`echo $RESULT | jq '.result[-1].message.photo[0].file_size'`
          IMG_WIDTH=`echo $RESULT | jq '.result[-1].message.photo[0].width'`
          IMG_HEIGHT=`echo $RESULT | jq '.result[-1].message.photo[0].height'`
          for func in $fIMG; do
            $func $IMG_ID $IMG_SIZE $IMG_WIDTH $IMG_HEIGHT
          done
        elif [ "$TAKED_LOC" != "null" ]; then
#          echo "Ho una localita'"
          LOC_LATITUDE=`echo $RESULT | jq '.result[-1].message.location.latitude'`
          LOC_LONGITUDE=`echo $RESULT | jq '.result[-1].message.location.longitude'`
          for func in $fLOC; do
            $func $LOC_LATITUDE $LOC_LONGITUDE
          done
        elif [ "$TAKED_DOC" != "null" ]; then
#          echo "Ho un documento"
          DOC_ID=`echo $RESULT | jq '.result[-1].message.document.file_id'`
          DOC_NAME=`echo $RESULT | jq '.result[-1].message.document.file_name'`
          DOC_MIME=`echo $RESULT | jq '.result[-1].message.document.mime_type'`
          DOC_SIZE=`echo $RESULT | jq '.result[-1].message.document.file_size'`
          for func in $fDOC; do
            $func $DOC_ID $DOC_NAME $DOC_MIME $DOC_SIZE
          done
        elif [ "$TAKED_MSG" != "null" ]; then
#          echo "Ho un testo"
          for func in $fTXT; do
            $func "$TAKED_MSG"
          done
        fi
      elif [ "$TAKED_MSG" == "\"$LOGIN\"" ]; then
#        echo "Mi sono loggato"
        OUTPUT=""
        for OWNR in ${OWNERS[@]}; do
          OUTPUT="$OWNR $OUTPUT"
        done
        echo "OWNERS=($OUTPUT$TAKED_FROM_ID)">/etc/telegram/.owners
        TEXT="%F0%9F%90%BE "`hostname -f`" alert!%0a"
        TEXT="$TEXT%E2%9E%96 %F0%9F%94%91 Now you are an administrator!"
        /etc/telegram/send.sh "$TAKED_FROM_ID" "$TEXT"
      fi
    fi
  fi
done
