# GitHub520-Update-Hosts

利用 crontab  定时更新 Linux 的 hosts 文件

任选一条

```bash
sh -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/gxggxl/GitHub520-Update-Hosts@master/install.sh)"
```

```bash
wget https://cdn.jsdelivr.net/gh/gxggxl/GitHub520-Update-Hosts@master/install.sh && chmod 700 install.sh && bash install.sh
```

## 重启 定时任务(cron)

```bash
#CentOS
service crond start

#Debian
/etc/init.d/cron restart
```

## HOSTS 文件更新地址

https://github.com/521xueweihan/GitHub520
