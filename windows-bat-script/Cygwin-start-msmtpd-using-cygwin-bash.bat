@echo off

PATH=C:\cygwin\bin\;%PATH%

chcp 65001
c:
chdir C:\cygwin\bin

bash /opt/msmtp-1.8.0/script/msmtpd-service.sh

