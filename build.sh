#!/bin/bash -ex

sudo apt install -y \
	build-essential \
	astyle \
	libncurses5-dev \
	libncursesw5-dev \
	libsdl2-dev \
	libsdl2-ttf-dev \
	libsdl2-image-dev \
	libsdl2-mixer-dev \
	libfreetype6-dev

mkdir -p target

if [ ! -d target/src ]; then
  mkdir -p target/src
  git clone https://github.com/CleverRaven/Cataclysm-DDA target/src
else
  pushd target/src
  git fetch --all
  #git status | grep 'Your branch is behind'
  git pull
  popd
fi

if [ ! -d target/src/data/sound/CDDA-Soundpack ]; then
  mkdir -p target/tmp
  if [ ! -d target/tmp/CDDA-Soundpack-master/CDDA-Soundpack ]; then
    if [ ! -f target/tmp/CDDA-Soundpack.zip ]; then
      wget -O target/tmp/CDDA-Soundpack.zip https://github.com/budg3/CDDA-Soundpack/archive/master.zip
    fi
    pushd target/tmp
  	rm -rf CDDA-Soundpack-master
    unzip CDDA-Soundpack.zip
    popd
  fi
  mv target/tmp/CDDA-Soundpack-master/CDDA-Soundpack target/src/data/sound/
fi

if [ ! -d target/src/data/sound/Otopack+ModsUpdates ]; then
  mkdir -p target/tmp
  if [ ! -d target/tmp/Otopack-Mods-Updates-master/Otopack+ModsUpdates ]; then
    if [ ! -f target/tmp/Otopack-Mods-Updates.zip ]; then
      wget -O target/tmp/Otopack-Mods-Updates.zip https://github.com/Kenan2000/Otopack-Mods-Updates/archive/refs/heads/master.zip
    fi
    pushd target/tmp
  	rm -rf Otopack-Mods-Updates-master
    unzip Otopack-Mods-Updates.zip
    popd
  fi
  mv target/tmp/Otopack-Mods-Updates-master/Otopack+ModsUpdates target/src/data/sound/
fi

cp cataclysm.desktop ~/.local/share/applications/

sudo rm -rf /usr/share/cataclysm-dda

pushd target/src
sudo make clean
sudo make install -j12 \
    PREFIX=/usr/ \
    NATIVE=linux64 \
    RELEASE=1 \
    LTO=1 \
    LOCALIZE=0 \
    USE_HOME_DIR=1 \
    TILES=1 \
    SOUND=1
sudo make clean
popd
