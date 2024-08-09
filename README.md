# Fabián Server 8.60 Downgrade

This repository will be for a future server, version 8.60 with everything recent from version 13x.
It will be updated every commit with everything new.

## Spr's For OTCLIENT
https://www.mediafire.com/file/xjq5fr29mrebfcb/860+SPR+Updated!.rar/file

**Download here OTC:**
https://github.com/OTCv8/otclientv8.git

**Activate in features 8.60:**

    g_game.enableFeature(GamePlayerMounts)
    g_game.enableFeature(GameSlowerManualWalking)
    g_game.enableFeature(GameEnhancedAnimations)
    g_game.enableFeature(GameIdleAnimations)
    g_game.enableFeature(GamePlayerMarket)

## How to compile Ubuntu 22.04
    
    sudo apt install libboost-date-time-dev
    
    sudo apt-get install cmake build-essential liblua5.4-dev libgmp3-dev libmysqlclient-dev libboost-system-dev libboost-iostreams-dev libboost-filesystem-dev libpugixml-dev libcrypto++-dev libfmt-dev libgmp-dev libboost-date-time-dev g++-10
    mkdir build && cd build
    cmake ..
    make

## How to compile

[Wiki](https://github.com/otland/forgottenserver/wiki/Compiling)
