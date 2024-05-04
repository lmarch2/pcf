# pcf
a tool for patchelf

# Install
先运行check.sh检查依赖，glibc-all-in-one默认安装在~，若需更改请修改check.sh和pcf.sh

如果glibc-all-in-one路径为~/glibc-all-in-one可下载pcf二进制文件直接使用

# Usage
Usage: pcf [-h, -f, -s, -d, -on, -off] <libc> <ld> <binary>

        -h: help

        -f <libc_file>: find libc version eg: pcf -f libc.so.6

        -s <libc_version>: search libc source  eg: pcf -s 2.27

        -d <libc_version>: download libc  eg: pc -d 2.27

        -on : enable ASLR

        -off : disable ASLR

# Version
## 1.0.0
暂不支持下载非稳定版libc和自定义下载libc（懒得写shell了）
