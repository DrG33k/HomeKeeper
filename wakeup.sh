#!/bin/bash
    TEXT="%E2%98%95 "`hostname -f`" wishes you a good day%0a"
    TEXT="$TEXT%E2%9E%96 %F0%9F%93%86 Uptime: "`uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 }'`"%0A"
    TEXT="$TEXT%E2%9E%96 %F0%9F%91%A5 User connected: "`uptime | grep -ohe '[0-9.*] user[s,]'`"%0A"
    TEXT="$TEXT%E2%9E%96 %F0%9F%92%BD Total disk usage: "`df / | tail -n +2 | awk '{ print $5}'`"%0A"
    TEXT="$TEXT%E2%9E%96 %F0%9F%94%97 Connection: "`netstat -ant | grep "ESTABLISHED" | wc -l`" established"
    /etc/telegram/broadcast.sh "$TEXT"
