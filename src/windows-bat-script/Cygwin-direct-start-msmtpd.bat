@echo off

PATH=C:\cygwin\bin\;%PATH%

chcp 65001
c:
chdir C:\cygwin\bin

..\opt\msmtp-1.8.0\bin\msmtpd --port=668 --command='TMPDIR=/opt/msmtp-1.8.0/var/tmp/ /opt/msmtp-1.8.0/bin/msmtp --file=/opt/msmtp-1.8.0/etc/msmtprc -f %%F'

