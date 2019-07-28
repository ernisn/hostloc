#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# Usage: bash hostloc_mu.sh

declare -A account_list

# user info: change them to your account username and password
account_list=([user1]="password1" [user2]="password2" [user_n]="password_n")

#
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"

# workdir
workdir="/root/hostloc_cookie"
[[ ! -d "$workdir" ]] && mkdir $workdir

function main() {
  account_name=($(echo ${!account_list[*]}))
  account_pswd=($(echo  ${account_list[*]}))

  for ((i=0; i<${#account_list[*]}; i++)); do
    [[ $i -gt 0 ]] && sleep $(shuf -i 123-321 -n 1)
    username="${account_name[i]}"
    password="${account_pswd[i]}"
	
    echo; echo -n $(date) $username登陆...
    data="mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1&fastloginfield=username&username=$username&cookietime=$(shuf -i 1234567-7654321 -n 1)&password=$password&quickforward=yes&handlekey=ls"
    curl -s -H "$UA" -c $workdir/cookie_$username --data "$data" "https://www.hostloc.com/member.php" | grep -o "www.hostloc.com" && status=0 || status=1
    [[ $status -eq 0 ]] && username_good[i]=${account_name[i]} && echo $(date) 成功
    [[ $status -eq 1 ]] && username_fail[i]=${account_name[i]} && echo && echo $(date) 失败 && continue
	
    echo $(date) 目前积分为：$(curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/home.php?mod=spacecp&ac=credit&op=base" | grep -oE "积分: </em>\w*" | awk -F'[>]' '{print $2}')
	
    times=$[10 - $(curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/home.php?mod=spacecp&ac=credit&op=log&suboperation=creditrulelog" | grep -A 2 "rid=16" | awk -F'[><]' 'NR==3{print $3}')]
    [[ $times -eq 0 ]] && echo $(date) 已完成 && continue
	
    echo -n $(date) 访问空间
	
    for((j = 6610; j <= 6630; j++)); do
    echo -n .
    curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/space-uid-$j.html" | grep -o "最近访客" >/dev/null && count[j]=$j
    sleep $(shuf -i 12-21 -n 1)
    [[ ${#count[*]} -eq $times ]] && unset count && break
    done
	
    echo; echo $(date) 完成
    echo $(date) 目前积分为：$(curl -s -H "$UA" -b $workdir/cookie_$username "https://www.hostloc.com/home.php?mod=spacecp&ac=credit&op=base" | grep -oE "积分: </em>\w*" | awk -F'[>]' '{print $2}')
  done

  # clean
  rm -rf $workdir

  # status
  [[ -n ${username_fail[*]} ]] && echo && echo $(date) $(echo  ${username_fail[*]}) Login Failed.
  [[ -n ${username_good[*]} ]] && echo && echo $(date) $(echo  ${username_good[*]}) Accomplished.
}

main
