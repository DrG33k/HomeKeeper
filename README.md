# HomeKeeper
**HomeKeeper** is an **open source** telegram bot, written in **bash**, for the automation of your server and home.
Extensible through **plugins**.

## Clone GitHub Repository

     git clone --recursive https://github.com/oscarcappa/homekeeper.git

## Preparation
* Connect to **@BotFather** via telegram.
* Type **/start** to start the conversation.
* Type **/newbot** to create a new bot.
* Choose the name of your bot, in my case **HomeKeeper**
* Now choose the username, in my case **HomeKeeper_bot**

## Installation

     sudo apt-get install libtool make autoconf

     git clone https://github.com/stedolan/jq.git
     cd jq
     autoreconf -i
     ./configure --disable-maintainer-mode
     make
     sudo make install
     sudo cp jq /usr/local/bin/
     cd ..

     cd homekeeper
     sudo chmod a+x build.sh
     sudo ./build.sh
     sudo /etc/telegram/bot.sh &
