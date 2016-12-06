if [ -n "$SSH_CLIENT" ]; then
  TEXT="%F0%9F%90%BE "`hostname -f`" new connection!%0a"
  TEXT="$TEXT%E2%9E%96 %F0%9F%91%A4 User: $USER%0A"
  TEXT="$TEXT%E2%9E%96 %F0%9F%8C%90 IP: "`echo $SSH_CLIENT | awk '{print $1}'`"%0A"
  /etc/telegram/broadcast.sh "$TEXT"
fi
