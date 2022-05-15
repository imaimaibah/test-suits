#!/bin/bash

. ./test_suits/global.env


function SUCCESS(){
	echo -e "\t\t[OK]"
}

function FAILURE(){
	echo -e "\t\t[BAD]"
	exit 127
}

function isProcessRunning(){

PROCESS=$1
FILE=${BASH_SOURCE[0]}
FUNCTION=${FUNCNAME[0]}
TMPFILE="/tmp/.${FUNCTION}.out"


	cat >./tmp/${FUNCTION}.exp <<EOL 
log_user 0
log_file -noappend -a ./logs/${FUNCTION}.log

spawn ssh -l $loginUser $t_SERVER
expect "$ "
send "sudo -i\n"
expect "# "
send "ps auxf |grep -v grep |/bin/grep $PROCESS\n"
expect -re ".*?\n"
while {1} {
	expect -re ".*\n" {
		puts -nonewline "\$expect_out(buffer)"
	} -re "# " {
		break
	}
}

EOL

	expect -f ./tmp/${FUNCTION}.exp > ./tmp/.${FUNCTION}_${PROCESS}.out
	if [ -s ./tmp/.${FUNCTION}.out ];then
		RET=0
	else
		RET=127
	fi

return $RET
}

function isPortListen(){

FILE=${BASH_SOURCE[0]}
FUNCTION=${FUNCNAME[0]}
TMPFILE="./tmp/.${FUNCTION}.out"

	PORTNUM=$(echo $1|awk -F/ '{print $1}')
	PROT=$(echo $1|awk -F/ '{print $2}')
	OPTION='-plant'
	if [ $PROT == "udp" ];then
		OPTION='-planu'
	fi

	cat >./tmp/${FUNCTION}.exp <<EOL 
log_user 0
log_file -noappend -a ./logs/${FUNCTION}.log

spawn ssh -l $loginUser $t_SERVER
expect "$ "
send "sudo -i\n"
expect "# "
send "netstat $OPTION |/bin/grep LISTEN | awk '{print \\\$4}'  | awk -F: '\\\$NF==$PORTNUM'\n"
expect -re ".*?\n"
while {1} {
	expect -re ".*\n" {
		puts -nonewline "\$expect_out(buffer)"
	} -re "# " {
		break
	}
}

EOL

	expect -f ./tmp/${FUNCTION}.exp > ./tmp/.${FUNCTION}_${PORTNUM}_${PROT}.out
	if [ -s ./tmp/.${FUNCTION}.out ];then
		RET=0
	else
		RET=127
	fi

return $RET
}

function isInstalled(){

FILE=${BASH_SOURCE[0]}
FUNCTION=${FUNCNAME[0]}
TMPFILE="/tmp/.${FUNCTION}.out"

	PKG=$1

	cat >./tmp/${FUNCTION}.exp <<EOL 
log_user 0
log_file -noappend -a ./logs/${FUNCTION}.log

spawn ssh -l $loginUser $t_SERVER
expect "$ "
send "sudo -i\n"
expect "# "
send "rpm -qa |/bin/grep $PKG\n"
expect -re ".*?\n"
while {1} {
	expect -re ".*\n" {
		puts -nonewline "\$expect_out(buffer)"
	} -re "# " {
		break
	}
}

EOL

	expect -f ./tmp/${FUNCTION}.exp > ./tmp/.${FUNCTION}_${PKG}.out
	if [ -s ./tmp/.${FUNCTION}.out ];then
		RET=0
	else
		RET=127
	fi

return $RET
}



function isHostnameSet(){
LHOSTNAME=$1
FILE=${BASH_SOURCE[0]}
FUNCTION=${FUNCNAME[0]}
TMPFILE="/tmp/.${FUNCTION}.out"


	cat >./tmp/${FUNCTION}.exp <<EOL 
log_user 0
log_file -noappend -a ./logs/${FUNCTION}.log

spawn ssh -l $loginUser $t_SERVER
expect "$ "
send "sudo -i\n"
expect "# "
send "hostname\n"
expect -re ".*?\n"
while {1} {
	expect -re ".*\n" {
		puts -nonewline "\$expect_out(buffer)"
	} -re "# " {
		break
	}
}

EOL

RHOSTNAME=$(expect -f ./tmp/${FUNCTION}.exp|sed -e 's/\r//')

	if [ "$LHOSTNAME" == "$RHOSTNAME" ];then
		RET=0
	else
		RET=127
	fi

return $RET
}

