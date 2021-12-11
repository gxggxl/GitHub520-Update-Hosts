#!/bin/bash
# -*- coding: utf-8 -*-
# @Software     : PyCharm
# @Author       : gxggxl
# @File         : install.sh
# @Time         : 2021/5/27 10:54
# @Project Name : GitHub520-Update-Hosts
# @Description  : GitHub520-Update-Hosts install
# @shellcheck   : https://www.shellcheck.net

updateTime="2021-12-11"
# 当前目录测试为 1 (0 是生产坏境)
Debug=0
# 系统路径
sysPath="/etc"
installationManual="/root/GitHub520host"
# 由于github仓库拉取较慢，所以会默认添加代理前缀，如不需要请移除
GithubProxyUrl="https://ghproxy.com/"
# 资源URL
HostUrl="https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts"
HostUrl="${GithubProxyUrl}https://raw.githubusercontent.com/521xueweihan/GitHub520/main/hosts"
MainshUrl="https://cdn.jsdelivr.net/gh/gxggxl/GitHub520-Update-Hosts@master/main.sh"
MainshUrl="${GithubProxyUrl}https://raw.githubusercontent.com/gxggxl/GitHub520-Update-Hosts/master/main.sh"
#echo $HostUrl
#curl -L $HostUrl
#exit
# 功能性函数：
purple() { #基佬紫
  echo -e "\\033[35;1m${*}\\033[0m"
}
tyblue() { #天依蓝
  echo -e "\\033[36;1m${*}\\033[0m"
}
green() { #原谅绿
  echo -e "\\033[32;1m${*}\\033[0m"
}
yellow() { #鸭屎黄
  echo -e "\\033[33;1m${*}\\033[0m"
}
red() { #姨妈红
  echo -e "\\033[31;1m${*}\\033[0m"
}
blue() { #蓝色
  echo -e "\\033[34;1m${*}\\033[0m"
}

if ((Debug == 1)); then
  sysPath="./etc"
  mkdir -p $sysPath
  installationManual="./GitHub520host"
else
  echo -e "你的安装目录为：${installationManual}"
fi

#检查账户权限
function check_root() {
  if [ $UID -eq 0 ]; then
    echo -e "当前用户是 ROOT 用户，可以继续操作" && sleep 1
  else
    echo -e "当前非 ROOT 账号(或没有 ROOT 权限)，无法继续操作，请更换 ROOT 账号或使用 su命令获取临时 ROOT 权限" && exit 1
  fi
}

#检查系统
function check_sys() {
  release=$(uname -a)
  strX="当前的操作系统是"
  if [[ $release =~ "Darwin" ]]; then
    echo "$strX MacOS"
    release="macos"
  elif [[ $release =~ "centos" ]]; then
    echo "$strX centos"
    release="centos"
  elif [[ $release =~ "ubuntu" ]]; then
    echo "$strX ubuntu"
    release="ubuntu"
  else
    echo "$release"
  fi
}

# 检查 curl 依赖
check_curl_installed_status() {
  if [ -z "$(command -v curl)" ]; then
    echo -e "curl 依赖没有安装，开始安装..."
    if [[ ${release} == "centos" ]]; then
      yum update && yum install curl -y
    elif [[ ${release} == "macos" ]]; then
      brew install curl
    else
      apt-get update && apt-get install curl -y
    fi
    if [ -z "$(command -v curl)" ]; then
      echo -e "curl 依赖安装失败，请检查！" && exit 1
    else
      echo -e "curl 依赖安装成功！"
    fi
  else
    echo -e "curl 已安装"
  fi
}

# 重启 定时任务
function restart_crontab() {
  check_sys
  red "尝试重启 定时任务服务"
  if [[ ${release} == "centos" ]]; then
    service crond restart
  elif [[ ${release} == "macos" ]]; then
    echo "======= macos，暂不支持 =========="
  else
    /etc/init.d/cron restart
  fi
  green "请检查 crond 服务是否重启 "
}

# 安装
function install() {
  echo "正在写入 hosts 文件......"
  curl -L "$HostUrl" >>$sysPath/hosts
  green "hosts 文件 理论写入成功！"

  if ((Debug == 1)); then
    echo "正在创建 $installationManual 目录"
    mkdir -p "$installationManual"
    green "success"
    echo "正在写入 更新脚本......"
    # 本地文件
    cat <main.sh >$installationManual/main.sh
    green "更新脚本 文件理论写入成功！"
    chmod +x $installationManual/main.sh
  else
    echo "正在创建 $installationManual 目录"
    mkdir -p "$installationManual"
    green "success"
    echo "正在写入 更新脚本......"
    curl -L "$MainshUrl" >$installationManual/main.sh
    green "更新脚本 文件理论写入成功！"
    chmod +x $installationManual/main.sh
  fi

  echo "正在添加 cron定时任务......"
  cat <<EOF
# GitHub520 Host Start
0 */6 * * * root bash $installationManual/main.sh > /dev/null 2>&1
# GitHub520 Host End
EOF
  cat <<EOF >>"$sysPath"/crontab
# GitHub520 Host Start
0 */6 * * * root bash $installationManual/main.sh > /dev/null 2>&1
# GitHub520 Host End
EOF
  green "cron定时任务 理论添加成功！"
}

# 卸载
function uninstall() {
  red "正在删除 hosts 文件..."
  cat <"$sysPath"/hosts | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/hosts
  green "hosts 文件 理论删除成功！"

  echo "正在删除 cron定时任务......"
  cat <"$sysPath"/crontab | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/crontab
  green "cron定时任务 理论删除成功！"

  red "正在删除 安装文件 ..."
  rm -rfv "$installationManual"
  green "安装文件 理论删除成功！"
}

function menu() {
  cat <<EOF
----------------------------------------------
|*******    $(green "GitHub520-Update-Hosts")    *******|
|*******  https://github.com/gxggxl/  *******|
|*******  updateTime : $(echo -e $updateTime)     *******|
----------------------------------------------
$(tyblue " (1) 安装服务")
$(red " (2) 卸载服务")
$(yellow " (3) 退出脚本")
EOF

  if ((OptionText == 1)); then
    red "输入无效"
  fi
  read -rep "请输入对应选项的数字：" numa

  case $numa in
  1)
    echo "安装服务!"
    if ((Debug == 0)); then
      check_root
    fi
    check_sys
    check_curl_installed_status
    install
    restart_crontab
    ;;
  2)
    echo "卸载服务!"
    uninstall
    restart_crontab
    ;;
  3)
    #    clear
    exit
    ;;
  *)
    OptionText=1
    menu
    ;;
  esac
}

menu
