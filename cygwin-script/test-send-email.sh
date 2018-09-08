#!/bin/sh

#replace receiver@receiver.com to your test receiver e-mail
cat /opt/msmtp-1.8.0/etc/msmtp-test-email.txt | /opt/msmtp-1.8.0/bin/msmtp --debug --file=/opt/msmtp-1.8.0/etc/msmtprc -- receiver@receiver.com
