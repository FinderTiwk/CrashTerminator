#!/bin/sh

#  resolveCrashLog.sh
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

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer

# param1  symbolicatecrash
# param2  *.crash
# param3  *.dSYM
# param4  output path

"${1}" "${2}" "${3}" > "${4}"