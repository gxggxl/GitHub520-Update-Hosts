#!/bin/bash
# -*- coding: utf-8 -*-
# @Software     : PyCharm
# @Author       : gxggxl
# @File         : install.sh
# @Time         : 2021/5/27 10:54
# @Project Name : GitHub520-Update-Hosts
# @Description  : scripts function describe
# https://www.shellcheck.net

me=0
installationManual="root/GitHub520host"
hostUrl="https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts"
# 系统路径
#sysPath="/etc"
sysPath="."
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

#检查账户权限
function check_root() {
  if [ $UID -ne 0 ]; then
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

# 安装
function install() {
  curl "$hostUrl" >>hosts

  mkdir -pv "$installationManual"

  cat <<EOF >>"$sysPath"/crontab
# GitHub520 Host Start
0 */6 * * * root bash /root/GitHub520host/mian.sh
# GitHub520 Host End
EOF
}

# 卸载
function uninstall() {
  red "正在删除 hosts 文件..."
  cat "$sysPath"/hosts | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/hosts
  cat "$sysPath"/crontab | sed '/^# GitHub520 Host Start/,/^# # GitHub520 Host Start/d' >tmpfile && mv tmpfile "$sysPath"/crontab
  red "正在删除 安装目录 ..."
  rm -rfv "$installationManual"
}

function menu() {
  cat <<EOF
----------------------------------------------
|********   $(green "GitHub520-Update-Hosts")   ********|
|*******  https://github.com/gxggxl/  *******|
----------------------------------------------
$(tyblue " 1)安装服务")
$(red " 2)卸载服务")
$(yellow " 3)退出")
EOF

  if ((me == 1)); then
    red "输入无效，请输入对应选项的数字："
  else
    echo "请输入对应选项的数字："
  fi

  read -r numa

  case $numa in
  1)
    echo "安装服务!"
    install
    ;;
  2)
    echo "卸载服务!"
    uninstall
    ;;
  3)
    clear
    exit
    ;;
  *)
    me=1
    menu
    ;;
  esac
}

check_root
check_sys
check_curl_installed_status
menu
