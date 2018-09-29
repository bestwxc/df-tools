#!/bin/bash
source ./scripts/color.sh
## 安装包名称
install_package=server-jre-8u181-linux-x64.tar.gz

## 安装包内目录名称
jdk_dir=jdk1.8.0_181

## 安装位置
target_dir=/usr/local/java

echo "安装信息：" | _color_ green bold
echo "安装包名："|_color_ green bold
echo "$install_package"
echo "JDK文件夹名："|_color_ green bold
echo "$jdk_dir"
echo "安装目录:"|_color_ green bold
echo "$target_dir"

