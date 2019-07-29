#!/bin/bash


# 判断参数是否正确

if [ $# != 2 ]; then
	echo -e "\033[31mPlease input projectname platform (e.g dws.sh gf36_z55 mt6739)\033[0m"
	kill 0
fi

projectname=$1
platform=$2

if [["$platform" != "mt6750" ]]; then
	echo -e "\033[31mPlease input projectname platform (e.g dws.sh gf36_z55 mt6739)\033[0m"
	kill 0
fi

bigproject=${projectname%%_*}

path=${platform}/${bigproject}/${projectname}

# 给dws文件的四个路分别赋值给变量




# 把其中一个dws文件复制到其他三个路径下