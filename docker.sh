#!/bin/bash

get_arch=`uname -m`
if [[ $get_arch == "x86_64" ]];then
    arch='x86'
elif [[ $get_arch == "aarch64" ]];then
    arch='arm'
elif [[ $get_arch == "mips64" ]];then
    arch='x86'
elif [[ $get_arch == "i686" ]];then
    arch='x86'
else
    echo "unknown!!"
    exit 0 
fi
if [[ $(docker ps|grep AutoSpy|awk '{print $10}') == "AutoSpy" ]]; then
	echo "登录成功后，请按CTRL+C退出"
	docker exec -it AutoSpy bash /start.sh
	echo "重启容器，spy将自动重启"
	docker restart AutoSpy
	echo -e "快去发送spy看看吧，如果出错，请确认自己的任务列表是否正确\n输入 docker logs AutoSpy 查看运行日志\n"	
	exit 0
fi
if [[ -d "$(pwd)"/AutoSpy  ]]; then
	docker stop AutoSpy
	docker rm AutoSpy
	echo "autospy配置文件已存在"
	docker run -dit --restart=always --name=AutoSpy --log-opt max-size=100m --log-opt max-file=3 -v "$(pwd)"/AutoSpy:/autospy --hostname=AutoSpy xieshang1111/auto_spy:$arch
else
	mkdir AutoSpy
    docker run -dit --restart=always --name=AutoSpy --hostname=AutoSpy xieshang1111/auto_spy:$arch
	docker cp AutoSpy:/ "$(pwd)"/AutoSpy
	docker stop AutoSpy
	docker rm AutoSpy	
	echo -n -e "检测到autospy配置文件不存在，如之前直装过AutoSpy,请输入绝对路径以完成配置文件一键迁移(如没安装过，直接回车即可)："
	read dir
	if [[ $dir != "" ]];then
	docker run -dit --restart=always --name=AutoSpy --log-opt max-size=100m --log-opt max-file=3 -v "$(pwd)"/AutoSpy:/autospy --hostname=AutoSpy xieshang1111/auto_spy:$arch
	cp $dir/auto_spy.yaml "$(pwd)"/AutoSpy
	docker exec -it AutoSpy bash /start.sh
	exit 0
else
	mkdir AutoSpy
	docker cp AutoSpy:/ "$(pwd)"/AutoSpy
	docker stop AutoSpy
	docker rm AutoSpy
	docker run -dit --restart=always --name=AutoSpy --log-opt max-size=100m --log-opt max-file=3 -v "$(pwd)"/AutoSpy:/autospy --hostname=AutoSpy xieshang1111/auto_spy:$arch
	cp "$(pwd)"/AutoSpy/auto_spy_simple.yaml "$(pwd)"/AutoSpy/auto_spy.yaml
	echo -e "现在可以去目录下[AutoSpy]里的[auto_spy.yaml]修改信息了\n修改完成后，请再次运行脚本\n"
	exit 0
    fi
fi