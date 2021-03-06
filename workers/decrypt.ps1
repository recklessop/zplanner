#!/usr/bin/pwsh
$Config = "/home/zerto/include/config.txt"
$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$env = get-content $Config | out-string | convertFrom-StringData
$env.password = $env.password | convertto-securestring -Key $Key
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($env.password)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
echo $UnsecurePassword
