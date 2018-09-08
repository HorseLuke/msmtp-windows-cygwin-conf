#!/bin/sh

#REMOVE --debug param IF YOU WANT TO USE IN PRODUCTION ENVIRONMENT OR HAS NO SEND MAIL PROBLEM
#MSMTP_COMMAND='TMPDIR=/opt/msmtp-1.8.0/var/tmp/ /opt/msmtp-1.8.0/bin/msmtp --debug --file=/opt/msmtp-1.8.0/etc/msmtprc -f %F'
MSMTP_COMMAND='TMPDIR=/opt/msmtp-1.8.0/var/tmp/ /opt/msmtp-1.8.0/bin/msmtp --file=/opt/msmtp-1.8.0/etc/msmtprc -f %F'
MSMPTD_PORT=668

while true
do
    sleep 5
	echo "starting msmtpd"
    /opt/msmtp-1.8.0/bin/msmtpd --port=${MSMPTD_PORT} --command="${MSMTP_COMMAND}"
done
