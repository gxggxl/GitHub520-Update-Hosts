#!/bin/bash
# -*- coding: utf-8 -*-
# @Software     : PyCharm
# @Author       : gxggxl
# @File         : main.sh
# @Time         : 2021/5/27 10:54
# @Project Name : GitHub520-Update-Hosts
# @Description  : scripts function describe
# https://www.shellcheck.net

sysPath="."
hostUrl="https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts"

# 安装
function updateHost() {
  echo "正在删除旧的 GitHub520Host 文件......"
  cat "$sysPath"/hosts | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/hosts
  echo "正在下载新的 GitHub520Host 文件......"
  curl "$hostUrl" >>"$sysPath"/hosts
  cat "$sysPath"/hosts
  echo "更新完成！！！！！！"
}

updateHost