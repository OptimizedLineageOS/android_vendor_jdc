#! /bin/bash

#      _____  __________      
#  __ / / _ \/ ___/_  _/__ ___ ___ _
# / // / // / /__  / // -_) _ `/  ' \ 
# \___/____/\___/ /_/ \__/\_,_/_/_/_/ 
#
# Copyright 2017 JDCTeam
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


export USE_CCACHE=1
export CCACHE_COMPRESS=1

ROM_NAME="Palm Project"
TARGET=s5neoltexx
VARIANT=userdebug
CM_VER=14.1
OUT="out/target/product/s5neoltexx"
FILENAME=PalmProject-"$CM_VER"-"$(date +%Y%m%d)"-"$TARGET"
AROMA_DIR=aroma

	
buildROM() {	
	echo "Cleaning OnePlus5 sources"
	rm -rf kernel/oneplus
	rm -rf vendor/oneplus
	rm -rf device/oneplus
	rm -rf device/oppo
	rm -rf prebuilts/snapdragon-llvm
	
	echo "Building..."
	lunch lineage_s5neoltexx-userdebug 
	make -j9 otapackage
	if [ "$?" == 0 ]; then
		echo "Build done"
	else
		echo "Build failed"
	fi
	
}

repackLibs() {
	echo "Taking libs..."
	FILENAME=PalmProject-"$CM_VER"-"$(date +%Y%m%d)"-"$TARGET"
	 echo " "
	LATEST=$(ls -t "$OUT" | grep -v .zip.md5 | grep .zip | head -n 1)
	TEMP2=tmpLib
    	if [ -d "$TEMP2" ]; then 
		echo "Removing old libs"
    		rm -rf "$TEMP2"
	fi
	mkdir "$TEMP2"
	echo "Unpacking ROM to temp folder"
	unzip -q "$OUT"/"$LATEST" -d"$TEMP2"
	
	cp -R device/samsung/exynos7580-common/lib.zip "$TEMP2"
	cd "$TEMP2"
	mkdir tmpExtract
	unzip -q lib.zip -d tmpExtract
        yes | cp -rf tmpExtract/lib/* system/lib
	echo "Repacking ROM"
	rm -rf tmpExtract
	rm -rf lib.zip
	zip -rq9 ../"$FILENAME".zip *
	cd ..
	md5sum "$FILENAME".zip > "$FILENAME".zip.md5
	echo "Cleaning..."
	rm -rf "$TEMP2"
	echo "Done"


	
}

doRefresh() {	
	echo "Refreshing build directories..."
	rm -rf build
	repo sync build
	repo sync build/kati
	repo sync build/soong
	repo sync build/blueprint
	
}


anythingElse() {
    echo -e "\e[1;91m==============================================================="
    echo -e "\e[0m "
    echo -e "\e[1;91mPlease update your device tree,EXTERNAL WEBVIEW,aroma,Substratum"
    echo ""
    echo "==============================================================="
    echo -e "\e[0m "
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
        read -t 3 -p "Clean ccache? 3 sec timeout? (y/n)";
	if [ "$REPLY" == "y" ]; then
		ccache -C
		ccache -c
	fi;
	echo "Making clean"
	make clean
	echo "Making clobber"
	make clobber
	
}




echo " "
echo " "
echo " "
echo " "
echo " "
echo -e "\e[1;92m--= \e[1;95mWelcome to the $ROM_NAME build script\e[1;92m =--"
echo -e "\e[0m "
echo " "
echo -e "\e[1;96mPlease make your selections carefully"
echo -e "\e[0m "
echo " "
. build/envsetup.sh > /dev/null
select build in "Deep clean (inc. ccache)" "Build ROM and repack" "Exit"; do
	case $build in
		"Deep clean (inc. ccache)" ) deepClean; anythingElse; break;;
		"Build ROM and repack" )  repackLibs; anythingElse; break;;
		"Exit" ) exit 0; break;;
	esac
done
exit 0
