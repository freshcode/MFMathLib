#!/bin/sh

#  bc.sh
#  MFMathLib
#  https://github.com/freshcode/MFMathLib
#
#  Public Domain
#  By Freshcode, Cutting edge Mac, iPhone & iPad software development. http://madefresh.ca/
#  Created by Dave Poirier on 2013-02-01.

echo "obase=16; ibase=16; print $1"|bc
echo

