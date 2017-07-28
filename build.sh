#! /bin/bash

#      _____  __________      
#  __ / / _ \/ ___/_  _/__ ___ ___ _
# / // / // / /__  / // -_) _ `/  ' \ 
# \___/____/\___/ /_/ \__/\_,_/_/_/_/ 
#
# Copyright 2016 JDCTeam
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


TEAM_NAME="JDCTeam"
TARGET=Cheeseburger
VARIANT=userdebug
CM_VER=14.1
OUT="out/target/product/cheeseburger"
FILENAME=Optimized-LineageOS-"$CM_VER"-"$(date +%Y%m%d)"-"$TARGET"
AROMA_DIR=aroma

buildROM()
{
	echo "Building..."
	. build/envsetup.sh
	time schedtool -B -n 1 -e ionice -n 1 brunch cheeseburger -j"$CPU_NUM" "$@"
	if [ "$?" == 0 ]; then
		echo "Build done"
	else
		echo "Build failed"
	fi
	croot
}


anythingElse() {
    echo " "
    echo " "
    echo "Anything else?"
    select more in "Yes" "No"; do
        case $more in
            Yes ) bash build.sh; break;;
            No ) exit 0; break;;
        esac
    done ;
}

deepClean() {
	ccache -C
	ccache -c
	echo "Making clean"
	make clean
	echo "Making clobber"
	make clobber
	
}

getBuild() {
	croot
	rm -rf build
	repo sync build
	repo sync build/kati
	repo sync build/soong
	repo sync build/blueprint
	
	
	echo -e "\e[1;91m==============================================================="
	echo -e "\e[0m "
	echo -e "\e[1;91mPlease update your device tree,EXTERNAL WEBVIEW,aroma,Substratum"
	echo ""
	echo "==============================================================="
	echo -e "\e[0m "
}

upstreamMerge() {

	croot
	echo "Refreshing manifest"
	repo init -u git://github.com/OptimizedLineageOS/manifests.git -b opt-cm-14.1
	echo "Syncing projects"
	repo sync --force-sync
	
	croot
        #echo "Upstream merging"
        ## Our snippet/manifest
        #ROOMSER=.repo/manifests/snippets/opt-cm-14.1.xml
        # Lines to loop over
        #CHECK=$(cat ${ROOMSER} | grep -e "<remove-project" | cut -d= -f3 | sed 's/revision//1' | sed 's/\"//g' | sed 's|/>||g')

        ## Upstream merging for forked repos
       # while read -r line; do
       #     echo "Upstream merging for $line"
       #    rm -rf $line
	#    repo sync $line
	  #  cd "$line"
	   # git branch -D opt-cm-14.1
	   # git checkout -b opt-cm-14.1
           # UPSTREAM=$(sed -n '1p' UPSTREAM)
           # BRANCH=$(sed -n '2p' UPSTREAM)

           # git pull https://www.github.com/"$UPSTREAM" "$BRANCH"
           # git push origin opt-cm-14.1
           # croot
        #done <<< "$CHECK"

}

useAroma()
{
    LOG="Unzipping files to repack with AROMA..."/$(date +"%T")
    if [ ! -d "$AROMA_DIR" ]; then
	echo "No AROMA directory found.Please check your sources"
	break;
    fi
    FILENAME=Optimized-LineageOS-"$CM_VER"-"$(date +%Y%m%d)"-"$TARGET"-AROMA
    echo " "
    LATEST=$(ls -t | grep -v .zip.md5 | grep .zip | head -n 1)
    TEMP2=tmpAroma
    if [ -d "$TEMP2" ]; then 
    rm -rf "$TEMP2"
    fi
    mkdir "$TEMP2"
    echo "Unpacking ROM to temp folder"
    unzip -q "$LATEST" -d"$TEMP2"
    echo "Removing META-INF folder"
    rm -rf "$TEMP2"/META-INF
    echo "Copying Aroma Installer"
    cp -r "$AROMA_DIR"/jdc "$TEMP2"/jdc
    cp -r "$AROMA_DIR"/xbin "$TEMP2"/xbin
    cp -r "$AROMA_DIR"/META-INF "$TEMP2"/META-INF

    cd "$TEMP2"
    echo "Repacking ROM"
    zip -rq9 ../"$FILENAME".zip *
    cd ..
    echo "Creating MD5"
    md5sum "$FILENAME".zip > "$FILENAME".zip.md5
    echo "Cleaning up"
    rm -rf "$TEMP2"
    echo "Done"
    LOG="Added AROMA.Build finished successfully"/$(date +"%T")

}


echo " "
echo -e "\e[1;91mWelcome to the $TEAM_NAME build script"
echo -e "\e[0m "
echo "Setting up build environment..."
echo "Setting build target $TARGET""..."
echo " "
echo -e "\e[1;91mPlease make your selections carefully"
echo -e "\e[0m "
echo " "
select build in "Refresh manifest,repo sync and upstream merge" "Build ROM"  "Add Aroma Installer to ROM"  "Refresh build directory" "Deep clean(inc. ccache)" "Exit"; do
	case $build in
		"Refresh manifest,repo sync and upstream merge" ) upstreamMerge; getBuild;anythingElse; break;;
		"Build ROM" ) buildROM; anythingElse; break;;
		"Add Aroma Installer to ROM" ) useAroma; anythingElse; break;;
		"Refresh build directory" ) getBuild; anythingElse; break;;
		"Deep clean(inc. ccache)" ) deepClean; anythingElse; break;;
		"Exit" ) exit 0; break;;
	esac
done
exit 0
