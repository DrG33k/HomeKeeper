#!/bin/bash
TEXT="%F0%9F%90%BE $HOSTNAME alert!%0a"
TEXT="$TEXT%E2%9E%96 %F0%9F%92%BE Download complete: $TR_TORRENT_NAME"
/etc/telegram/broadcast.sh  "$TEXT"
