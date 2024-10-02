#!/bin/bash

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then 
    echo "请以root权限运行此脚本"
    exit 1
fi

# 关闭防火墙
ufw disable
echo "已完成：关闭防火墙"

# 修改系统变量
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo "已完成：修改系统变量"

# 保存生效
sysctl -p
echo "已完成：应用系统变量修改"

# 创建一个2G的swap文件
dd if=/dev/zero of=/home/swap bs=1024 count=2048000
echo "已完成：创建2G swap文件"

# 将文件格式转换为swap格式
mkswap /home/swap
echo "已完成：转换swap文件格式"

# 挂载swap分区
swapon /home/swap
echo "已完成：挂载swap分区"

# 修改/etc/fstab文件以确保重启后swap分区仍然生效
echo '/home/swap swap swap default 0 0' >> /etc/fstab
echo "已完成：配置开机自动挂载swap"

echo "所有操作已完成。"
