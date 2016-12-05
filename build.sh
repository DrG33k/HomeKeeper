#!/bin/bash
#Chiedo i due parametri di configurazione
echo "Scegli una password che permettera' di diventare amministratore del bot, poi premi enter."
read LOGIN

echo "Inserisci l'HASH completo del tuo bot, poi premi enter."
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

read -r -p "Do you want an alert on user login? [y/N] " response
case $response in
  [yY][eE][sS]|[yY]) 
    echo "Set telegram.sh"
    if [ -f "/etc/profile.d/telegram.sh" ]
    then
      rm /etc/profile.d/telegram.sh
    fi
    chmod a+x /etc/profile.d/telegram.sh
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
    mv pluginDOC/webcam.sh /etc/telegram/pluginTXT/webcam.sh
    echo "Remember to edit /etc/telegram/pluginTXT/webcam.sh file"
    ;;
  *)
    ;;
esac

mv pluginDOC/ping.sh /etc/telegram/pluginTXT/ping.sh
mv pluginDOC/publicip.sh /etc/telegram/pluginTXT/publicip.sh

cp bot.sh /etc/telegram/
chmod a+x /etc/telegram/bot.sh

#cp -r pluginTXT/ /etc/telegram
#cp -r pluginDOC/ /etc/telegram
#cp -r pluginLOC/ /etc/telegram
#cp -r pluginIMG/ /etc/telegram
