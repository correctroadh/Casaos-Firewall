#!/bin/bash

# 获取系统信息
GetSysInfo() {
  if [ -s "/etc/redhat-release" ]; then
    SYS_VERSION=$(cat /etc/redhat-release)
  elif [ -s "/etc/issue" ]; then
    SYS_VERSION=$(cat /etc/issue)
  fi
  SYS_INFO=$(uname -a)
  SYS_BIT=$(getconf LONG_BIT)
  MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
  CPU_INFO=$(getconf _NPROCESSORS_ONLN)

  echo -e ${SYS_VERSION}
  echo -e Bit:${SYS_BIT} Mem:${MEM_TOTAL}M Core:${CPU_INFO}
  echo -e ${SYS_INFO}
}

((EUID)) && sudo_cmd="sudo"

NftablesInit(){
  AddNftablesTable filter
  AddNftablesCahin filter input
  AllowOtherPort filter input
}

AddNftablesTable(){
  # $1 表示表名
  $sudo_cmd nft add table inet $1
}

AddNftablesCahin(){
  # $1 表示表名 $2 表示链名
  $sudo_cmd nft add chain inet $1 $2
}

ClosePort(){
  # $1 表示表名 $2 表示链名 $3 表示端口号
  $sudo_cmd nft add rule inet $1 $2 tcp dport $3 drop
}

OpenPort(){
  # $1 表示表名 $2 表示链名 $3 表示端口号
  $sudo_cmd nft add rule inet $1 $2 tcp dport $3 accept
}

AllowOtherPort(){
  # $1 表示表名 $2 表示链名 
  $sudo_cmd nft add rule rult $1 $2 accept
}

GetNftablesVersion(){
    nft --version
}

GetNftablesRuleset(){
    $sudo_cmd nft list ruleset
}

AddNftablesSet(){
    nft add set inet filter $1 \{ type inet_service \; flags interval \; \}
}


GetRuleFromSet(){
    nft list set inet filter $1
}

