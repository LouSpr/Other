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
	docker exec -it AutoSpy bash autospy/start.sh
	echo "重启容器，spy将自动重启"
	docker restart AutoSpy
	echo -e "快去发送spy看看吧，如果出错，请确认自己的任务列表是否正确\n输入 docker logs AutoSpy 查看运行日志\n"	
	exit 0
fi
if [[ -d "$(pwd)"/AutoSpy  ]]; then
	echo "autospy配置文件已存在"
	docker run -dit --restart=always --name=AutoSpy --log-opt max-size=100m --log-opt max-file=3 -v "$(pwd)"/AutoSpy:/autospy --hostname=AutoSpy xieshang1111/auto_spy:$arch
else
	docker run -dit --restart=always --name=AutoSpy --log-opt max-size=100m --log-opt max-file=3 -v "$(pwd)"/AutoSpy:/autospy --hostname=AutoSpy xieshang1111/auto_spy:$arch
	cp "$(pwd)"/AutoSpy/auto_spy_simple.yaml "$(pwd)"/AutoSpy/auto_spy.yaml
	echo -e "现在可以去目录下[AutoSpy]里的[auto_spy.yaml]修改信息了\n修改完成后，请再次运行脚本\n"
	exit 0
    fi
fi