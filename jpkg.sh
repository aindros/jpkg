#-
# Copyright 2023 Alessandro Iezzi <aiezzi AT alessandroiezzi PERIOD it>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

#!/bin/sh

parse_opt()
{
	while [ $# -gt 0 ]; do
		case $1 in
			-o|--output)
				shift
				OUT_DIR=$1
			;;
			*)
				LIB=$1
			;;
		esac
		shift
	done
}

parse_opt $@

# This script uses the repository of Maven.
MVN_URL=https://repo.maven.apache.org/maven2

# Maven organize each library using a group, a name and a version. So, a library
# must be defined in the form:
# 	group-name:library-name:vesion
# Following variables are used to build the correct Maven URL.

GROUP_ID=`echo $LIB | sed -E 's/\:.*//g'`
ARTIF_ID=`echo $LIB | sed -E 's/.*\:(.*)\:.*/\1/g'`
VERSION=`echo $LIB | sed -E 's/.*\://g'`
LIBRARY=$ARTIF_ID-$VERSION.jar

# Defines the wget command, here is built the correct Maven URL to the library
WGET="wget -q $MVN_URL/`echo $GROUP_ID | sed -E 's/\./\//g'`/$ARTIF_ID/$VERSION/$LIBRARY"

# If the destination directory is defined, WGET and OUT_LIBRARY must be redefined
OUT_LIBRARY=$LIBRARY
if [ ! -z $OUT_DIR ]; then
	WGET=$WGET" -P $OUT_DIR"
	OUT_LIBRARY=$OUT_DIR/$OUT_LIBRARY
fi

# If the library isn't downloaded:
if [ ! -f $OUT_LIBRARY ]; then
	$WGET
fi

echo 'Library downloaded in:' $OUT_LIBRARY
