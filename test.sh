#!/usr/bin/env bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/www/server/nvm/versions/node/v12.18.3/bin:~/bin
export PATH

#项目路径
gitPath="/www/wwwroot/admin"
#git 远程仓库地址
gitSSH="git@e.coding.net:hetaoo/new751_react.git"
#构建完成需要部署到的目录
buildPath=""
#需要部署的分支
gitBranch="Test"
#是否更新标签
isChanged=0

#
#buildScript="buildScript.sh"


#创建代码仓库
checkGit() {
	if [ -d "$gitPath" ];then
		cd $gitPath
		#判断是否存在git目录
		if [ ! -d ".git" ]; then
			echo "在该目录下克隆 git"
			git clone -b $gitBranch  $gitSSH gittemp
			mv gittemp/* gittemp/.[^.]* .
		rm -fr gittemp
		isChanged = 1
		fi	
	else
        echo "该项目路径不存在"
        echo "End"
        exit 1
	fi
}


#拉取代码
pullCode() {
	cd $gitPath
	echo "正在拉取远程代码"
	#判断是否在所部署分支
	nowBranch=`git branch | grep "*" | awk '{print $2}'`
	if [ $nowBranch != $gitBranch ];then
		git checkout $gitBranch
	fi	

	git fetch 
	res=`git rev-parse HEAD @{u} | uniq | wc -l`
	if [ $res = 2 ] || [ $isChanged = 1 ]; then
		git pull origin $gitBranch

		echo "本地代码已更新"
	else
		echo "本地代码已是最新代码，无需更新。"	
		exit 1
	fi	
}

# if [ -f "$buildScript" ]; then
#   chmod +x $buildScript
#   ./$buildScript
# else
#   echo '不存在执行脚本';
# fi
# echo "脚本执行结束"


buildReact() {
	which yarn 
	if [ $? != 0 ];then
		echo "yarn 不存在	"
		exit 1
	fi
	
    cd $gitPath
    
	echo "更新依赖中..."
	a=`yarn install`
	if [ $? = 0 ];then 
		echo "依赖更新完成"
	else 
		echo "更新依赖失败"
		echo a
	fi		


	echo "开始构建项目..."
	build=`yarn build-production`
	if []; then
		echo "项目构建完成..."
	else 
		echo "项目构建失败	"
		echo build
	fi	
}


#复制生成的文件到
cpFile() {


}


#
main() {
	checkGit
	pullCode
	buildReact
	cpFile
}

main 2>&1
