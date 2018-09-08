# 在Windows + Cygwin运行msmtp的配置文件示例（含运行msmtpd为服务的脚本）

[English Version README](./README.md)


## 背景知识

msmtp是一个SMTP客户端，兼容sendmail命令行，非常适合替代sendmail使用。开发和维护者是Martin Lambers。

主页和源代码下载地址：https://marlam.de/msmtp/


msmtp与2018-9-4发布1.8.0版本，从这个版本开始，它拥有了一个微型的SMTP服务器应用，msmtpd。

msmtpd可用于无法直接调用sendmail命令行的场景。

详细文档见: https://marlam.de/msmtp/msmtp.html#Minimal-SMTP-server-_0028msmtpd_0029

```

Msmtpd is a minimal SMTP server that pipes mails to msmtp (or some other program) for delivery. It is intended to be used with system services that expect an SMTP server on the local host and cannot be configured to use the sendmail interface that msmtp provides.

Msmtpd handles local SMTP clients. It listens on 127.0.0.1 port 25 by default, but can also run without its own network sockets in inetd mode, where it handles a single SMTP session on standard input / output.

In the string that defines the command that msmtpd pipes each mail to, the first occurence of ‘%F’ will be replaced with the envelope from address. Furthermore, all recipients of the mail will be appended as arguments. The command must not write to standard output, as that would mess up the SMTP session.

Only run msmtpd if you know you need it. Only use a local interface to listen on. Take care to run it with correct user rights and permissions (e.g. use ‘CAP_NET_BIND_SERVICE’ to bind to port 25 instead of running as root, or use systemd with inetd service capabilities). Be aware that the pipe command will be run as the same user that msmtpd runs as.


````



## Windows + Cygwin + msmtpd

然而msmtpd这个新特性暂时不支持原生windows socket，这使得想以MINGW64编译成原生Windows应用时，会失败报错。

所以目前来说，如果要在Windows使用msmtpd，你暂时只能依赖Cygwin。

备注： Windows上的Linux子系统（Windows Subsystem for Linux，简称WSL）也行。但只支持Windows 10 Insider Preview Build 14328、Windows 10 Fall Creators Update (16215)、或者 Windows Server 1709和之后的版本。


参考资料：

https://gitlab.marlam.de/marlam/msmtp/issues/12



## 在Windows使用msmtpd的常见场景

1. PHP mail()函数的原生支持。

在以前，windows并没有sendmail或者类似的替代品，这使得依赖sendmail的PHP mail()函数无法在Windows正常使用。

现在有了msmtpd，PHP mail()也能在Windows正常使用啦！

php.ini配置示例:

```

[mail function]
; For Win32 only.
; http://php.net/smtp
SMTP = 127.0.0.1

; http://php.net/smtp-port
; msmtpd监听的端口
smtp_port = 668

; For Win32 only.
; http://php.net/sendmail-from
sendmail_from = "my_email_account@aaaaa.com"

```

## 关于本项目

本项目主要包含一些文件，用于在Windows运行msmtp和msmtpd，例如：

  - 运行msmtp的配置文件

  - 以服务形式运行msmtpd的脚本

注意：

  - 本项目要求msmtp版本号为1.8.0或以上。

  - 本项目假设Cygwin安装在Windows目录`C:\cygwin`。你需要自行修正配置和脚本文件，指向到真正的安装目录。
  
  - 本项目假设msmtp 1.8.0安装在Cygwin目录`/opt/msmtp-1.8.0` (Windows目录为`C:\cygwin\opt\msmtp-1.8.0`)。你需要自行修正配置和脚本文件，指向到真正的安装目录。
  
  - 本项目假设如下msmtp 1.8.0编译参数和命令行，并且在这些编译参数下测试通过（假设msmtp 1.8.0源代码为`D:\src\msmtp-1.8.0`）:

```
cd "D:\src\msmtp-1.8.0"
autoreconf -i
./configure --prefix=/opt/msmtp-1.8.0/ --with-tls=gnutls  --disable-dependency-tracking
make
make install
```


  - 在Cygwin编译msmtp 1.8.0之前，你需要安装如下packages:

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

