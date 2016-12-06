#!/bin/bash
command -v jq >/dev/null 2>&1 || { echo >&2 "I require jq but it's not installed."; exit 1; }

MYUSER=`whoami`
if [ "$MYUSER" != "root" ]; then
  echo "Use sudo ./build.sh"
fi

#Chiedo i due parametri di configurazione
echo "Choose a password, then press ENTER. Send it to the bot to begin administrator."
echo "E.g. \"mypassword\""
read LOGIN

echo "Insert the complete HASH, then press ENTER."
echo "E.g. \"123456789:AAAA1-aB1cD2eF3gH4iL5mN6oP7qR8sT9uV\""
read HASH

# Creo e setto la cartella comune
if [ -d "/etc/telegram" ]; then
  rm -r /etc/telegram
fi
mkdir /etc/telegram
chmod 777 /etc/telegram
mkdir /etc/telegram/pluginTXT
mkdir /etc/telegram/pluginDOC
mkdir /etc/telegram/pluginIMG
mkdir /etc/telegram/pluginLOC

# Inizializzo gli amministratori e la configurazione
echo "OWNERS=(0)">/etc/telegram/.owners
chmod 777 /etc/telegram/.owners

echo "HASH=\"$HASH\"">/etc/telegram/.config
echo "LOGIN=\"$LOGIN\"">>/etc/telegram/.config
chmod 777 /etc/telegram/.config

echo "Set broadcast.sh"
mv broadcast.sh /etc/telegram/broadcast.sh
chmod a+x /etc/telegram/broadcast.sh

echo "Set send.sh"
mv send.sh /etc/telegram/send.sh
chmod a+x /etc/telegram/send.sh

mv homekeeperd /etc/init.d/homekeeperd
chmod a+x /etc/init.d/homekeeperd
update-rc.d homekeeperd defaults

read -r -p "Do you want an alert on user login? [y/N] " response
case $response in
  [yY][eE][sS]|[yY]) 
    echo "Set homekeeper.sh"
    if [ -f "/etc/profile.d/homekeeper.sh" ]
    then
      rm /etc/profile.d/homekeeper.sh
    fi
    mv telegram.sh /etc/profile.d/homekeeper.sh
    chmod a+x /etc/profile.d/homekeeper.sh
    ;;
  *)
    ;;
esac

read -r -p "Do you want a daily stats? [y/N] " response
case $response in
  [yY][eE][sS]|[yY])
    echo "Modify crontab"
    if grep -q "wakeup.sh" "/etc/crontab"; then
      echo "WakeUp message already present."
    else
      echo "00 07   * * *   root   /etc/telegram/wakeup.sh">>/etc/crontab
    fi
    echo "Imposto wakeup.sh"
    mv wakeup.sh /etc/telegram/wakeup.sh
    chmod a+x /etc/telegram/wakeup.sh
    ;;
  *)
    ;;
esac

read -r -p "Do you use transmission? [y/N] " response
case $response in
  [yY][eE][sS]|[yY])
    echo "Move transmission file"
    mv complete.sh /etc/telegram/complete.sh
    chmod a+x /etc/telegram/complete.sh
    mv pluginDOC/torrent.sh /etc/telegram/pluginDOC/torrent.sh
    echo "Set /etc/telegram/complete.sh as complete script"
    ;;
  *)
    ;;
esac

read -r -p "Do you have webcam? [y/N] " response
case $response in
  [yY][eE][sS]|[yY])
    echo "Move webcam file"
    mv pluginTXT/webcam.sh /etc/telegram/pluginTXT/webcam.sh
    echo "Remember to edit /etc/telegram/pluginTXT/webcam.sh file"
    ;;
  *)
    ;;
esac

mv pluginTXT/ping.sh /etc/telegram/pluginTXT/ping.sh
mv pluginTXT/publicip.sh /etc/telegram/pluginTXT/publicip.sh

cp bot.sh /etc/telegram/
chmod a+x /etc/telegram/bot.sh

#cp -r pluginTXT/ /etc/telegram
#cp -r pluginDOC/ /etc/telegram
#cp -r pluginLOC/ /etc/telegram
#cp -r pluginIMG/ /etc/telegram
