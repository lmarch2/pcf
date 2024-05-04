#!/bin/bash

# 设置颜色变量
COLOR_GREEN="\033[32m"  # 绿色
COLOR_YELLOW="\033[33m" # 黄色
COLOR_RED="\033[31m"    # 红色
COLOR_RESET="\033[0m"   # 重置颜色

echo -e "${COLOR_YELLOW}[+] 开始检查环境${COLOR_RESET}"

# 检查是否安装了 shc
if ! command -v shc &>/dev/null; then
	echo -e "${COLOR_YELLOW}[+] 检测到 shc 未安装，开始安装...${COLOR_RESET}"
	sudo apt update && sudo apt install -y shc
	if [ $? -eq 0 ]; then
		echo -e "${COLOR_GREEN}[+] shc 安装成功${COLOR_RESET}"
	else
		echo -e "${COLOR_RED}[-] shc 安装失败${COLOR_RESET}"
		exit 1
	fi
fi

# 检查是否安装了 glibc-all-in-one
if [ ! -d ~/glibc-all-in-one ]; then
	echo -e "${COLOR_YELLOW}[+] 检测到 glibc-all-in-one 未安装，开始下载...${COLOR_RESET}"
	cd ~ || exit 1
	git clone https://github.com/matrix1001/glibc-all-in-one.git
	if [ $? -eq 0 ]; then
		echo -e "${COLOR_GREEN}[+] glibc-all-in-one 下载成功${COLOR_RESET}"
	else
		echo -e "${COLOR_RED}[-] glibc-all-in-one 下载失败${COLOR_RESET}"
		exit 1
	fi
fi
echo -e "${COLOR_GREEN}[+] 检查完成${COLOR_RESET}"

echo -e "${COLOR_YELLOW}[+] 开始编译 ${COLOR_RESET}"
shc -f pcf.sh
mv pcf.sh.x pcf
sudo mv pcf /usr/bin/
rm pcf.sh.x.c
pcf -h

if [ $? -eq 0 ]; then
	echo -e "${COLOR_GREEN}[+] 编译完成${COLOR_RESET}"
else
	echo -e "${COLOR_RED}[-] 编译失败${COLOR_RESET}"
	exit 1
fi
