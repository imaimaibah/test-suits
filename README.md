Test Suits for Sainsbury project
================================

> ## Overview

This is a test suit writen in bash and expect(python or ruby later on). 

> ## Test suits

### common.sh
* isProcessRunning

To check the process running on the tartget server

> args

| Parameter number | Parameter | Mandatory| 
|------------------|-----------|----------|
|1| Process name | * |

Ex.
```
isProcessRunning "httpd"
```

* isPortListen

To check if the target server is listening on the specified port

> args

| Parameter number | Parameter | Mandatory| 
|------------------|-----------|----------|
|1| port number/protocol | * |

Ex.
```
isPortListen 80/tcp
```

* isInstalled

To check if specified package is installed on the target server

> args

| Parameter number | Parameter | Mandatory| 
|------------------|-----------|----------|
|1| Package name | * |

Ex.
```
# isInstalled httpd
```

* isHostnameSet

To check hostname is set on the target server. This function does not output the result of the expect script to tmp directory.

> args

| Parameter number | Parameter | Mandatory| 
|------------------|-----------|----------|
|1| Host name | * |

Ex.
```
# isHostnameSet dev-ipa1.rd.sainsburys-poc.uk
```


> ## Directory Structure

1. ./test_suits
 * This directory contains test series of bash scripts.
2. ./tmp
 * This directory contains expect scripts created by bash scripts. Also it contains result of the expect scripts
3. ./logs
 * This directory contains outputs of expect scripts

## How to run
./deploy_check.sh


