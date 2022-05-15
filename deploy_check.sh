#!/bin/bash

. ./test_suits/common.sh

. ./test_suits/IPA.sh

echo -n "COMMON: isProcessRunning(sss)"
isProcessRunning "sss" && SUCCESS || FAILURE

echo -n "COMMON: isPortListen(80/tcp)"
isPortListen '80/tcp' && SUCCESS || FAILURE

echo -n "COMMON: isInstalled(httpd)"
isInstalled "httpd" && SUCCESS || FAILURE

echo -n "COMMON: isHostnameSet"
isHostnameSet 'dev-ipa1.rd.sainsburys-poc.uk' && SUCCESS || FAILURE

echo -n "IPA: isReplicate"
IPA_isReplicate dev-ad1.js.sainsburys-poc.uk:winsync dev-ipa2.rd.sainsburys-poc.uk:master dev-ipa1.rd.sainsburys-poc.uk:master && SUCCESS || FAILURE


