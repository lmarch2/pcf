# pcf
a tool for patchelf

做pwn题老是输patchelf的命令，虽然有历史命令可查但还是写个工具更方便吧

# Install
先运行check.sh检查依赖，glibc-all-in-one默认安装在~，若需更改请修改check.sh和pcf.sh

如果glibc-all-in-one路径为$HOME/glibc-all-in-one可下载pcf二进制文件直接使用

# Usage

check环境
![image](https://github.com/lmarch2/pcf/assets/120877309/de90e7e2-e741-40c2-919c-b204d440eb8c)

Usage: pcf [-h, -f, -s, -d, -on, -off] <libc> <ld> <binary>

        -h: help

        -f <libc_file>: find libc version eg: pcf -f libc.so.6

        -s <libc_version>: search libc source  eg: pcf -s 2.27

        -d <libc_version>: download libc  eg: pc -d 2.27

        -on : enable ASLR

        -off : disable ASLR

先查找所给libc详细版本
![image](https://github.com/lmarch2/pcf/assets/120877309/661a9afe-fb17-450f-8cf5-039b4de91962)

pcf -s 2.27发现没有想要的版本，使用-d下载（下载来源均为glibc-all-in-one）
![image](https://github.com/lmarch2/pcf/assets/120877309/d76d6f59-9bbe-4ff2-8d53-23fd2c228d2e)

选择想要patch的libc版本和二进制程序
![image](https://github.com/lmarch2/pcf/assets/120877309/2e46c2c2-6939-481f-b0fb-0b980600219c)


# Version
## 1.0.0
暂不支持下载非稳定版libc和自定义下载libc（懒得写shell了）

-f支持查找Ubuntu和Debian

开关ASLR只是附加功能）
