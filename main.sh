#!/bin/bash
# -*- coding: utf-8 -*-
# @Software     : PyCharm
# @Author       : gxggxl
# @File         : main.sh
# @Time         : 2021/5/28 10:50
# @Project Name : GitHub520-Update-Hosts
# @Description  : 脚本功能更新hosts文件

# 当前目录测试 0 是生产坏境
debug=0
# 资源配置
sysPath="/etc"
hostUrl="https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts"

if ((debug == 1)); then
  sysPath="../etc"
  mkdir -p $sysPath
else
  wwww=$sysPath
  sysPath=$wwww
fi
# 更新系统 hosts 文件
function updateHost() {
  echo "正在删除旧的 GitHub520Host 文件......"
  cat <"$sysPath"/hosts | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/hosts
  echo "正在下载新的 GitHub520Host 文件......"
  curl "$hostUrl" >>"$sysPath"/hosts
  cat "$sysPath"/hosts
  echo "更新完成！！！！！！"
}

updateHost
