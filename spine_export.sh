#!/bin/bash

set -e

if [ ! -z "$DEBUG" ]; then
	set -x
fi

# Configuration variables
# The easiest way to configure these, without breaking future script updates
# would be to create a new script where these variables are properly setup
GRAPHICS_PATH=${GRAPHICS_PATH:-"C:\Users\Bigglz\bigglz Dropbox\박제이\bigglz\01.팀\02. 캐릭터팀\01.비글즈 앱_작업\11. 모션 관련\2D SPINE\motion_spine\4foot_Lv1\베이직스킨"}
EXPORT_PATH=${EXPORT_PATH:-"C:\Users\Bigglz\bigglz Dropbox\박제이\bigglz\01.팀\02. 캐릭터팀\01.비글즈 앱_작업\11. 모션 관련\2D SPINE\motion_spine_json\test_json"}
SPINE_VERSION=${SPINE_VERSION:-"3.8.99"}
EXPORT_SETTINGS=${EXPORT_SETTINGS:-"C:\Users\Bigglz\bigglz Dropbox\박제이\bigglz\01.팀\02. 캐릭터팀\01.비글즈 앱_작업\11. 모션 관련\2D SPINE\json 내보내기 설정\4족보행 펫 내보내기 설정.export.json"}
SPINE_EXE=${SPINE_EXE:-""}

# try to auto detect spine executable path
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="C:/Program Files/Spine/Spine.com"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="/mnt/c/Program Files/Spine/Spine.com"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="/Applications/Spine.app/Contents/MacOS/Spine"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="$HOME/Spine/Spine.sh"
fi
if [ ! -f "$SPINE_EXE" ]; then
	echo "Unable to find suitable spine executable. Please specify one in SPINE_EXE variable."
	exit 1
fi

# if no export settings file is presented use json+pack by default
if [ ! -f "$EXPORT_SETTINGS" ]; then
	EXPORT_SETTINGS="json+pack"
fi

echo "Spine exe: $SPINE_EXE"
echo "Spine version: $SPINE_VERSION"

spine_args=""
spine_args="${spine_args} -u $SPINE_VERSION"
spine_args="${spine_args} ${@:2}"
while IFS= read -r -d $'\0' file; do
	setting_file="${file%.*}.export.json"
	if [ ! -f "${setting_file}" ]; then
		setting_file="${EXPORT_SETTINGS}"
	fi
	spine_args=$"${spine_args} -i $file -o `dirname ${EXPORT_PATH}/$file` -e ${setting_file}"
done < <(find "${GRAPHICS_PATH}" -iname \*.spine -type f -print0)

"$SPINE_EXE" $spine_args
