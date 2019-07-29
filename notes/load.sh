#!/bin/bash
   #echo $#

																					#      ./DQ/tools/load.sh gf506_s618 mt6750
																																															#      $#=2


   if [ $# != 2 ]; then
      echo -e "\033[31mplease input projectname platform (e.g build_release.sh dq_test mt6750)\033[0m"
      kill 0
   fi
   #echo ==============================
   projectname=$1                                                     										        # projectname=gf506_s618
   platform=$2             																	 # platform=mt6750
   if [[ "$platform" != "mt6750" ]];  then 
      echo -e "\033[31mplease  input projectname platform (e.g build_release.sh dq_test mt6750)\033[0m"
      kill 0
   fi
   #echo ${projectname}
   bigproject=${projectname%%_*}   														# bigproject=gf506
  # echo ${bigproject}
   path=${platform}/${bigproject}/${projectname}                   										 # path=mt6750/gf506/gf506_s618
   #echo ${path}
   src=./DQ/project/${path}																# src=./DQ/project/mt6750/gf506/gf506_s618
   if [ ! -d  "$src" ]; then
     echo -e "\033[31m$src not exist\033[0m"
     kill 0
   fi
   #save base
   pjmk=$(find $src -name 'ProjectConfig.mk')													# pjmk=$(find ./DQ/project/mt6750/gf506/gf506_s618 -name 'ProjectConfig.mk')
   																					#         =./DQ/project/mt6750/gf506/gf506_s618/device/mediateksample/k50v1/ProjectConfig.mk
   
   ./DQ/tools/modem.sh $pjmk $platform
   #echo $pjmk
   base=${pjmk%/ProjectConfig.mk}															# base=./DQ/project/mt6750/gf506/gf506_s618/device/mediateksample/k50v1
   #echo $base
   base=${base##*/}																		# base=k50v1
   echo $base > dqbase																	# dpbase=k50v1
   platformnum=${platform:((${#platform} - 2))}												# platformnum=50
   echo "$projectname"_"$platformnum" > projectname											# projectname=gf506_s618_50
   
  #Linc add for DWS Copy Start 2018.01.03
   if [[ "$platform" == "mt6739" ]];then
   DWS_PATH=${src}/kernel-4.4/drivers/misc/mediatek/dws/${platform}
   elif [[ "$platform" == "mt6750" ]];then
   DWS_PATH=${src}/kernel-3.18/drivers/misc/mediatek/dws/mt6755								# DWS_PATH=./DQ/project/mt6750/gf506/gf506_s618/kernel-3.18/drivers/misc/mediatek/dws/mt6755
   fi
   if [  -e  "${DWS_PATH}/${base}.dws" ]; then
   echo -e "\033[32m DWS exist,Start To Copy DWS...\033[0m"									# DWS exist,Start To Copy DWS...
   #Rename 
   mkdir ./DQ/dws_temp
   cp -a ${DWS_PATH}/* ./DQ/dws_temp/
   mv ./DQ/dws_temp/${base}.dws ./DQ/dws_temp/codegen.dws
   #copy 
   mkdir -p ${src}/vendor/mediatek/proprietary/bootable/bootloader/lk/target/${base}/dct/dct/ && cp -a ./DQ/dws_temp/* "$_"
   mkdir -p ${src}/vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${base}/dct/dct/ && cp -a ./DQ/dws_temp/* "$_"
   mkdir -p ${src}/vendor/mediatek/proprietary/custom/${base}/kernel/dct/dct/ && cp -a ./DQ/dws_temp/* "$_"
   rm -rf ./DQ/dws_temp
   echo -e "\033[32m Auto Copy DWS File Done ...\033[0m"
   else
   echo -e "\033[31m DWS Not Exist,Please Check ...\033[0m"
   fi
   #DWS Copy End
   
   																					# 下面三条命令是这个脚本的核心
   driver=DQ/driver																		# driver=DQ/driver
   cp -ar ${driver}/* ./																	#  cp -ar DQ/driver/* ./
   cp -ar ${src}/* ./																		# cp -ar ./DQ/project/mt6750/gf506/gf506_s618/* ./
   
 #Linc   Delete IMX230 PDAF DRV
 #rm -rf ./vendor/mediatek/proprietary/custom/mt6755/hal/pd_buf_mgr/imx230_mipi_raw
 
#型号切换
   custom_model=$(find $src -name 'custom_model.h')											# custom_model=$(find ./DQ/project/mt6750/gf506/gf506_s618 -name 'custom_model.h')

   if [ -f "$custom_model" ];then
   echo ${custom_model}
   cp ${custom_model} ./system/vold/
   cp ${custom_model} ./DQ/apps/denqinCommon/src/java/com/denqin/common/CustModel.java

   sed -i "s/\/\//""/g" ./DQ/apps/denqinCommon/src/java/com/denqin/common/CustModel.java
   sed -i "s/const/static/g" ./DQ/apps/denqinCommon/src/java/com/denqin/common/CustModel.java
   sed -i "s/char\*/String/g" ./DQ/apps/denqinCommon/src/java/com/denqin/common/CustModel.java  
   fi
