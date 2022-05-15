#!/bin/bash

. ./test_suits/global.env
. ./test_suits/IPA.env


function IPA_isReplicate(){
FILE=${BASH_SOURCE[0]}
FUNCTION=${FUNCNAME[0]}
TMPFILE="/tmp/.${FUNCTION}.out"


	START=`awk '/^<<__EXPECT__/ {print NR+1}' $FILE`
	END=`awk '/^__EXPECT__/ {print NR-1}' $FILE`


	(echo "set server $t_SERVER";echo "set DMPASSWD $DMPASSWD";echo "set loginUser $loginUser";awk 'NR>='"$START"'&&NR<='"$END" $FILE) | expect > $TMPFILE

	for i in $@;do 

		LINE=`echo $i|awk -F: '{print $1 ": " $2}'`

		grep "$LINE" $TMPFILE >/dev/null 2>&1
		RET=$?
		if [ $RET -ne 0 ];then
			FRET=$RET
		fi

	done 

return $FRET

<<__EXPECT__

log_user 0 
spawn ssh -l $loginUser $server
expect "$ "
send "sudo -i\n"
expect "# "
send "ipa-replica-manage list\n"
expect "Directory Manager password:"
send "$DMPASSWD\n"
expect -re ".*?\n"
while {1} {
	expect -re ".*\n" {
		send_user --  "$expect_out(buffer)"
	} -re "# " {
		break
	}
}

__EXPECT__

}

