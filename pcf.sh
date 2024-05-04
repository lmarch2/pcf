#!/bin/bash

COLOR_GREEN="\033[32m"  # 绿色
COLOR_YELLOW="\033[33m" # 黄色
COLOR_RED="\033[31m"    # 红色
COLOR_RESET="\033[0m"   # 重置颜色

off_alsr() {
	sudo su -c "echo 0 > /proc/sys/kernel/randomize_va_space"
	echo -e "\n${COLOR_YELLOW}[*] ASLR disabled"
	echo -n "/proc/sys/kernel/randomize_va_space: "
	cat /proc/sys/kernel/randomize_va_space
	echo -e "${COLOR_RESET}"
}

on_alsr() {
	sudo su -c "echo 2 > /proc/sys/kernel/randomize_va_space"
	echo -e "\n${COLOR_YELLOW}[*] ASLR enabled"
	echo -n "/proc/sys/kernel/randomize_va_space: "
	cat /proc/sys/kernel/randomize_va_space
	echo -e "${COLOR_RESET}"
}

pcf() {
	if [ "$1" == "-on" ]; then
		on_alsr
		return 0
	fi
	if [ "$1" == "-off" ]; then
		off_alsr
		return 0
	fi
	if [[ -f "$1" && -f "$2" && -f "$3" ]]; then
		local a=$1
		local b=$2
		local c=$3

		patchelf --replace-needed libc.so.6 ./"$a" ./"$c"
		patchelf --set-interpreter ./"$b" ./"$c"

		if [ $? -eq 0 ]; then
			echo -e "${COLOR_GREEN}[+] Patch applied libc <$a> and ld <$b> to <$c>${COLOR_RESET}"
		else
			echo -e "${COLOR_RED}[-] Patch failed${COLOR_RESET}"
		fi

	elif [ "$1" == "-f" ] && [ -f "$2" ]; then
		re1=$(strings "$2" | grep "ubuntu")
		re2=$(strings "$2" | grep Debian)
		if [ -n "$re1" ] || [ -n "$re2" ]; then
			echo -e "${COLOR_GREEN}[+] Found libc version:${COLOR_RESET}"
			echo -e "$re1"
			echo -e "$re2"
		else
			echo -e "${COLOR_RED}[-] Not Found${COLOR_RESET}"
		fi

	elif [ "$1" == "-s" ]; then
		local dir="$HOME/glibc-all-in-one/libs"
		local search_term=$2
		local found_dirs=$(find "$dir" -maxdepth 1 -type d -name "*$search_term*" -printf "%f\n" | sed 's/^1)//' | sort)

		if [ -z "$found_dirs" ]; then
			echo -e "${COLOR_YELLOW}No libc found '$search_term' Please use -d download${COLOR_RESET}"
			return 1
		else
			echo -e "${COLOR_GREEN}[+] Found libc '$search_term':${COLOR_RESET}"
			echo -e "$found_dirs"
			echo -e "${COLOR_YELLOW}Select libc version: ${COLOR_RESET}"
			read folder
			if [[ $folder != *"$search_term"* ]]; then
				echo -e "${COLOR_RED}[-] Patch failed${COLOR_RESET}"
				return 0
			fi

			if [ -e "$dir/$folder/libc-$search_term.so" ]; then
				libcpath=$dir/$folder/libc-$search_term.so
				ldpath=$dir/$folder/ld-$search_term.so
			else
				libcpath=$dir/$folder/libc.so.6
				ldpath=$dir/$folder/ld-linux-x86-64.so.2
			fi

			if [ -n "$folder" ]; then
				local bin
				echo -e "${COLOR_YELLOW}Your binary: ${COLOR_RESET}"
				read bin
				patchelf --replace-needed libc.so.6 $libcpath ./$bin
				patchelf --set-interpreter $ldpath ./$bin
				if [ $? -eq 0 ]; then
					echo -e "${COLOR_GREEN}[+] Patch applied libc <$libcpath> and ld <$ldpath> to <$bin>${COLOR_RESET}"
				else
					echo -e "${COLOR_RED}[-] Patch failed${COLOR_RESET}"
				fi

			else
				echo -e "${COLOR_RED}Invalid selection. Please try again.${COLOR_RESET}"
			fi
		fi

	elif [ "$1" == "-d" ]; then
		local dir="$HOME/glibc-all-in-one/libs"
		local search_term=$2
		result=$(cat ~/glibc-all-in-one/list | grep "$search_term")
		if [ -z "$result" ]; then
			echo -e "${COLOR_RED}Not Found ${COLOR_RESET}"
			return 0
		else
			echo -e "${COLOR_GREEN}[+] Found libc $search_term${COLOR_RESET}"
			echo -e "${COLOR_YELLOW}Select libc version: ${COLOR_RESET}"
			echo "$result"
			local libc
			read libc
		fi

		$HOME/glibc-all-in-one/download $libc
		if [ $? -eq 0 ]; then
			echo -e "${COLOR_GREEN}[+] Downloaded libc $search_term${COLOR_RESET}"
		else
			echo -e "${COLOR_RED}[-] Download failed${COLOR_RESET}"
		fi

	else
		echo -e "Usage: pcf [-h, -f, -s, -d] <libc> <ld> <binary>\n
        -h: help\n
        -f <libc_file>: find libc version eg: pcf -f libc.so.6\n
        -s <libc_version>: search libc source  eg: pcf -s 2.27\n
        -d <libc_version>: download libc  eg: pc -d 2.27\n
        -on : enable ASLR\n
        -off : disable ASLR\n"
		return 0
	fi

}

pcf "$@"
