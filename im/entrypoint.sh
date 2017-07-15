#!/bin/bash

user="$USER"  
group="$USER"
logfile="/root/app.log"
#create group if not exists  
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ]  
then  
    groupadd -g 1000 $group  
fi  
  
#create user if not exists  
egrep "^$user" /etc/passwd >& /dev/null  
if [ $? -ne 0 ]  
then  
    useradd -d "/home/$user" -m -u 1000 -g $group $user
fi

if [ "$user"x != "root"x ]; then
    logfile="/home/$user/app.log"
fi

if [ ! -e "/opt/deepinwine/apps/Deepin-QQ/Initialized" ]; then
    if [ "$user"x != "root"x ]; then
        chown -R "$group:$user" /TencentFiles
        ln -s "/TencentFiles" "/home/$user/Tencent Files"
    else
        ln -s "/TencentFiles" "/root/Tencent Files"
    fi
    touch /opt/deepinwine/apps/Deepin-QQ/Initialized
fi

echo "use:$group $user"
su - "$user" <<EOF
if [ "$1" ]; then
    echo "deepin-wine $1"
    deepin-wine $1
else
    echo "启动 QQ"
    nohup /opt/deepinwine/apps/Deepin-QQ/run.sh >"$logfile" &
    tail -fn 0 "$logfile"
fi

exit 0
EOF