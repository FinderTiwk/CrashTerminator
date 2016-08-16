#!/bin/sh

#  Dwarfdump.sh
#  CrashTerminator
#
#   _____ _           _          _____ _          _
#  |  ___(_)_ __   __| | ___ _ _|_   _(_)_      _| | __
#  | |_  | | '_ \ / _` |/ _ \ '__|| | | \ \ /\ / / |/ /
#  |  _| | | | | | (_| |  __/ |   | | | |\ V  V /|   <
#  |_|   |_|_| |_|\__,_|\___|_|   |_| |_| \_/\_/ |_|\_\
#
#  Created by _Finder丶Tiwk on 16/8/14.
#  Copyright © 2016年 _Finder丶Tiwk. All rights reserved.

# param1  .dSYM 或者 .app/appName 的路径
dwarfdump --uuid "${1}"
