#!/bin/bash

## -------- 工程配置区，请根据工程实际进行修改--------------------
## 应用分组名称
group_id=dz-kfb
## 应用名称
application_name=application_name
## 提供的profile
profile_list=dev,test
## 应用端口 用于生成超链接用
application_port=17000
## 日志目录
log_dir=/opt/log/$group_id/$application_name
## 实际机器上额外配置文件，多次部署后不用多次修改
ext_config_file=/home/scripts/config/$application_name-config.sh