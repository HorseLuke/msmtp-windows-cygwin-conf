# msmtp configure example in Windows + Cygwin (with msmtpd service script)

[Chinese Version README (With more detail) / 中文说明文档](./README-zh-CN.md)


## Background

msmtp is an SMTP client, has sendmail compatible interface. The Maintainer is Martin Lambers.

Source Code: https://marlam.de/msmtp/


In 2018-09-04, msmtp released version 1.8.0. In this version, it introduces a Minimal SMTP server(msmtpd).


Doc: https://marlam.de/msmtp/msmtp.html#Minimal-SMTP-server-_0028msmtpd_0029

```

Msmtpd is a minimal SMTP server that pipes mails to msmtp (or some other program) for delivery. It is intended to be used with system services that expect an SMTP server on the local host and cannot be configured to use the sendmail interface that msmtp provides.

Msmtpd handles local SMTP clients. It listens on 127.0.0.1 port 25 by default, but can also run without its own network sockets in inetd mode, where it handles a single SMTP session on standard input / output.

In the string that defines the command that msmtpd pipes each mail to, the first occurence of ‘%F’ will be replaced with the envelope from address. Furthermore, all recipients of the mail will be appended as arguments. The command must not write to standard output, as that would mess up the SMTP session.

Only run msmtpd if you know you need it. Only use a local interface to listen on. Take care to run it with correct user rights and permissions (e.g. use ‘CAP_NET_BIND_SERVICE’ to bind to port 25 instead of running as root, or use systemd with inetd service capabilities). Be aware that the pipe command will be run as the same user that msmtpd runs as.


````



## Windows + Cygwin + msmtpd

New feature msmtpd lacks of support windows socket, thus compiling in MINGW64 will failed.

So if you want to use msmtpd in Windows, you have to use Cygwin. 

Note: Windows Subsystem for Linux (WSL) is OK, but this feature only supported in Windows 10 Insider Preview Build 14328 / Windows 10 Fall Creators Update (16215) / Windows Server 1709 and later.

Ref: https://gitlab.marlam.de/marlam/msmtp/issues/12




## Common scenarios for using msmtpd in Windows

1. PHP mail() function

In the past, Windows does not support sendmail, but PHP mail() function rely on this.

Now with msmtpd, you can easily use PHP mail() function in Windows.

php.ini Example:

```

[mail function]
; For Win32 only.
; http://php.net/smtp
SMTP = 127.0.0.1

; http://php.net/smtp-port
; msmtpd port
smtp_port = 668

; For Win32 only.
; http://php.net/sendmail-from
sendmail_from = "my_email_account@aaaaa.com"

```


## About this repo

This repo contains some files to run msmtp and msmtpd in Windows with Cygwin. For example: 

  - Configuration files to run msmtp

  - Scripts to run msmtpd in Service

Attention:

  - This repo need msmtp 1.8.0 and above.

  - This repo assumes Cygwin installation path in Windows Dir `C:\cygwin`. You have to change some file to fit the real installation path.
  
  - This repo assumes msmtp 1.8.0 installation path in Cygwin path `/opt/msmtp-1.8.0` (Windows Dir is `C:\cygwin\opt\msmtp-1.8.0`). You have to change some file to fit the real installation path.
  
  - This repo was tested on msmtp 1.8.0 with these compiling commands (assumes msmtp 1.8.0 source code in `D:\src\msmtp-1.8.0`):

```
cd "D:\src\msmtp-1.8.0"
autoreconf -i
./configure --prefix=/opt/msmtp-1.8.0/ --with-tls=gnutls  --disable-dependency-tracking
make
make install
```

  - Before compiling msmtp 1.8.0 in Cygwin, you need to install these packages:

```
gnutls
libgnutls-devel
libglib2.0-devel
libidn2-devel
libtasn1-devel
libp11-kit-devel
libunbound-common
libunbound-devel
libunbound2
libiconv-devel
gettext-devel
gcc-core
gcc-g++
make
automake
autoconf
```