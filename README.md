## Hostloc 一键签到

1. 浏览器手动方式签到：

   确保 Hostloc 账号处于登录状态后，[点击此处](http://loc.ernyx.com/) 即可自动签到。
   
2. 服务器脚本自动签到：

   `wget https://raw.githubusercontent.com/ernisn/hostloc/master/hostloc.sh` 下载脚本；
   
   编辑脚本中的用户名和密码；
   
   `crontab -e` 添加定时任务：
   ```
   10 11 * * * root bash /root/hostloc.sh >>/var/log/hostloc.log
   # 执行时间自己修改，避免设在凌晨以确保签到成功；
   # 日志位置: /var/log/hostloc.log
   ```
