#!/bin/bash
# -*- coding: utf-8 -*-
# @Software     : PyCharm
# @Author       : gxggxl
# @File         : main.sh
# @Time         : 2021/5/28 10:50
# @Project Name : GitHub520-Update-Hosts
# @Description  : 脚本功能更新hosts文件

# 当前目录测试为 1 (0 是生产坏境)
Debug=0
# 资源配置
sysPath="/etc"
# 由于github仓库拉取较慢，所以会默认添加代理前缀，如不需要请移除
GithubProxyUrl="https://ghproxy.com/"
# 资源URL
HostUrl="https://cdn.jsdelivr.net/gh/521xueweihan/GitHub520@main/hosts"
HostUrl="${GithubProxyUrl}https://raw.githubusercontent.com/521xueweihan/GitHub520/main/hosts"

if ((Debug == 1)); then
  sysPath="../etc"
  mkdir -p $sysPath
else
  echo -e "你的系统目录为：${sysPath}"
fi
# 更新系统 hosts 文件
function updateHost() {
  echo "正在删除旧的 GitHub520Host 文件......"
  cat <"$sysPath"/hosts | sed '/^# GitHub520 Host Start/,/^# GitHub520 Host End/d' >tmpfile && mv tmpfile "$sysPath"/hosts
  echo "正在下载新的 GitHub520Host 文件......"
  curl -L "$HostUrl" >>"$sysPath"/hosts
  cat "$sysPath"/hosts
  echo "更新完成！！！！！！"
}

updateHost
