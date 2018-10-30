#!/bin/bash

## -------- 运行配置 --------------------------------------------
## 当前激活的profile
active_profile=test
## 虚拟机参数
vmargs="-Xmx1024m -Xms512m"

## -------- 工程配置区，请根据工程实际进行修改--------------------
## 为了便于工程版本管理，application_name和 profile_list移到project.sh
# source ./project.sh
# 由于当前执行目录的问题，在需要引用的文件中source

## -------- 通用配置区，一般不用调整 -----------------------------
jdk_dir=/usr/local/java/jdk
JAVA=$jdk_dir/bin/java

## -------- 自动生成配置区，使用setup.sh生成，请勿手动修改--------
## 可执行jar全路径
JAR_PATH=/root/workspace/bin/application.jar


